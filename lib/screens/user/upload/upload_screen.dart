import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:printick/services/supabase_service.dart';
import 'package:provider/provider.dart';
import 'package:printick/providers/upload_provider.dart';
import 'package:printick/services/file_service.dart';
import 'package:pdfx/pdfx.dart';
import 'package:printick/services/pdf_service.dart';
import 'package:printick/services/supabase_storage_service.dart';
// import 'package:printick/services/order_supa_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:printick/core/utils/app_message.dart';
import 'package:printick/screens/user/checkout/checkout_screen.dart';
import 'package:printick/services/settings_service.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 177, 186, 246),
              Color.fromARGB(255, 234, 191, 233),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// 🔹 Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),

                  child: Column(
                    children: [
                      const _HeaderSection(),
                      const SizedBox(height: 10),

                      /// Upload card
                      Consumer<UploadProvider>(
                        builder: (context, provider, _) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: provider.file == null
                                ? const _UploadCard()
                                : const SizedBox(),
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      /// Preview
                      Consumer<UploadProvider>(
                        builder: (context, provider, _) {
                          if (provider.file == null) return const SizedBox();

                          return FilePreviewCard(
                            file: provider.file!,
                            fileName: provider.fileName!,
                            onRemove: provider.removeFile,
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      const PrintOptions(),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              /// Bottom button
              const _BottomUploadButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload 📄",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Upload your documents",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
          Row(
            children: [
              _iconButton(Icons.history),
              const SizedBox(width: 10),
              _iconButton(Icons.more_vert),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      // padding: const EdgeInsets.only(bottom: 20),
      child: Icon(icon),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 110, // 🔥 reduced height
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF8E7CFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.cloud_upload, color: Colors.white),
            ),

            const SizedBox(width: 15),

            // Text
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose File",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Only PDF Supported",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Button
            ElevatedButton(
              onPressed: () async {
                final provider = context.read<UploadProvider>();

                final file = await FileService.pickPdf();

                if (file != null) {
                  provider.setFile(file); // 👈 shows Detecting...
                  final pages = await PdfService.getPageCount(file);
                 await provider.setPages(pages); // 👈 updates instantly
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Choose"),
            ),
          ],
        ),
      ),
    );
  }
}

class FilePreviewCard extends StatefulWidget {
  final File file;
  final String fileName;
  final VoidCallback onRemove;

  const FilePreviewCard({
    super.key,
    required this.file,
    required this.fileName,
    required this.onRemove,
  });

  @override
  State<FilePreviewCard> createState() => _FilePreviewCardState();
}

class _FilePreviewCardState extends State<FilePreviewCard> {
  late PdfControllerPinch controller;

  @override
  void initState() {
    super.initState();

    controller = PdfControllerPinch(
      document: PdfDocument.openFile(widget.file.path),
    );
  }

  @override
  void dispose() {
    controller.dispose(); // 👈 IMPORTANT
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.85),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: PdfViewPinch(
                  controller: controller, // ✅ FIXED
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.fileName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatefulWidget {
  const _ToggleSwitch();

  @override
  State<_ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<_ToggleSwitch> {
  bool isColor = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isColor,
      onChanged: (value) {
        setState(() {
          isColor = value;
        });
      },
    );
  }
}
// class PrintOptions extends StatefulWidget {
//   const PrintOptions({super.key});

//   @override
//   State<PrintOptions> createState() => _PrintOptionsState();
// }

class PrintOptions extends StatelessWidget {
  const PrintOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<UploadProvider>(context);

return FutureBuilder(

  future: SettingsService.getSettings(),

  builder: (context, snapshot) {

    if (!snapshot.hasData) {
      return const SizedBox();
    }

    final settings = snapshot.data!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(226, 255, 255, 255),
              Color.fromARGB(255, 232, 162, 226),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),

boxShadow: [

  BoxShadow(
    color: Colors.black.withOpacity(0.04),
    blurRadius: 18,
    offset: const Offset(0, 8),
  ),
],
        ),
        child: Column(
          children: [
            /// COPIES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "No. of Copies",
style: const TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 14.5,
  letterSpacing: 0.2,
),                ),

                Row(
                  children: [
                   _btn(Icons.remove, () async {
  await provider.decreaseCopies();
}),
SizedBox(width: 4),
                 Container(

  padding: const EdgeInsets.symmetric(
    horizontal: 10,
    vertical:2 ,
  ),

  decoration: BoxDecoration(

    color: Colors.white.withOpacity(0.55),

    borderRadius:
        BorderRadius.circular(12),

    border: Border.all(
      color: Colors.white.withOpacity(0.6),
    ),
  ),

  child: Text(
    "${provider.copies}",

    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
  ),
),
SizedBox(width: 4),

                   _btn(Icons.add, () async {
  await provider.increaseCopies();
}),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// PRINT TYPE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Print Type",
style: const TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 14.5,
  letterSpacing: 0.2,
),                ),

               Row(
  children: [

    _chip(

      title: "B/W",

      subtitle:
          "₹${settings.bwPrice.toStringAsFixed(0)}/page",

      active: !provider.isColor,

      onTap: () async {
        await provider.toggleColor(false);
      },
    ),

    const SizedBox(width: 8),

    _chip(

      title: "Color",

      subtitle:
          "₹${settings.colorPrice.toStringAsFixed(0)}/page",

      active: provider.isColor,

      onTap: () async {
        await provider.toggleColor(true);
      },
    ),
  ],
),
              ],
            ),

const SizedBox(height: 15),

/// PAPER SIZE
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [

    const Text(
      "Paper Size",
style: const TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 14.5,
  letterSpacing: 0.2,
),    ),
Row(
  children: [

    _chip(

      title: "A4",

      subtitle: "Standard",

      active:
          provider.paperSize == "A4",

      onTap: () async {
        await provider.setPaperSize("A4");
      },
    ),

    const SizedBox(width: 8),

    _chip(

      title: "A3",

      subtitle:
          "${((settings.a3Multiplier - 1) * 100).toInt()}%",

      active:
          provider.paperSize == "A3",

      onTap: () async {
        await provider.setPaperSize("A3");
      },
    ),
  ],
),
  ],
),
const SizedBox(height: 15),

/// PRINT SIDE
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [

    const Text(
      "Print Side",
style: const TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 14.5,
  letterSpacing: 0.2,
),    ),

    Row(
  children: [

    _chip(

      title: "Single",

      subtitle: "Normal",

      active:
          !provider.isDoubleSide,

      onTap: () async {
        await provider.toggleDoubleSide(false);
      },
    ),

    const SizedBox(width: 8),

    _chip(

      title: "Double",

      subtitle:
          "Save ${(100 - (settings.doubleSideMultiplier * 100)).toInt()}%",

      active:
          provider.isDoubleSide,

      onTap: () async {
        await provider.toggleDoubleSide(true);
      },
    ),
  ],
),
  ],
),
            const SizedBox(height: 15),
   /// PAGES
  Container(

  padding: const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  ),

  decoration: BoxDecoration(

    color:
        Colors.white.withOpacity(0.32),

    borderRadius:
        BorderRadius.circular(14),

    border: Border.all(
      color:
          Colors.white.withOpacity(0.45),
    ),
  ),

  child: Row(

    mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

    children: [

  Expanded(

    child: Row(
      children: [

        Container(

          height: 36,
          width: 36,

          decoration: BoxDecoration(

            color:
                const Color(
                  0xFF7B6EF6,
                ).withOpacity(0.12),

            borderRadius:
                BorderRadius.circular(10),
          ),

          child: const Icon(
            Icons.description_outlined,
            color: Color(0xFF7B6EF6),
            size: 18,
          ),
        ),

        const SizedBox(width: 12),

        Flexible(

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              const Text(
                "Total Pages",

                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                ),
              ),

              const SizedBox(height: 2),

              Text(

                provider.pages == null
                    ? "Detecting..."
                    : provider.isDoubleSide
                        ? "${provider.pages} File Pages x ${provider.copies} Copies"
                        : "${provider.pages} File Pages x ${provider.copies} Copies",

                softWrap: true,

                style: TextStyle(
                  fontSize: 12,

                  color:
                      Colors.black.withOpacity(
                    0.55,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),

  const SizedBox(width: 10),

  Text(

    provider.pages == null
        ? "--"
        : "${provider.isDoubleSide
            ? ((provider.pages! / 2).ceil() * provider.copies)
            : (provider.pages! * provider.copies)}",

    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
],
  ),
),
            const SizedBox(height: 15),

      Container(
  margin: const EdgeInsets.only(top: 6),
  padding: const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  ),
  decoration: BoxDecoration(
    color:
        Colors.white.withOpacity(0.35),
    borderRadius:
        BorderRadius.circular(14),
    border: Border.all(
      color:
          Colors.white.withOpacity(0.45),
    ),
  ),

  child: Row(
    mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

    children: [
  Expanded(
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        const Text(
          "Estimated Cost",

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.5,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          "Excludes taxes & extra fees",

          softWrap: true,

          style: TextStyle(
            fontSize: 11,
            color:
                Colors.black.withOpacity(
              0.5,
            ),
          ),
        ),
      ],
    ),
  ),

  const SizedBox(width: 10),
  Text(
provider.priceBreakdown == null
    ? "--"
    : "₹${provider.priceBreakdown!.paperCost <= 1
        ? "1.00"
        : provider.priceBreakdown!.paperCost.toStringAsFixed(2)}",

    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
],
  ),
),
                    const SizedBox(height: 15),
          ],
        ),
      ),
    );
      },
);
  }

  /// 🔘 BUTTON (+ / -)
 Widget _btn(
  IconData icon,
  VoidCallback onTap,
) {

  return GestureDetector(

    onTap: onTap,

    child: AnimatedContainer(

      duration:
          const Duration(milliseconds: 180),

      height: 34,
      width: 34,

      decoration: BoxDecoration(

        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C63FF),
            Color(0xFF8E7CFF),
          ],
        ),

        borderRadius:
            BorderRadius.circular(10),

        boxShadow: [

          BoxShadow(
            color:
                const Color(
                  0xFF6C63FF,
                ).withOpacity(0.22),

            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Icon(
        icon,
        color: Colors.white,
        size: 18,
      ),
    ),
  );
}

Widget _chip({

  required String title,
  required String subtitle,

  required bool active,

  required VoidCallback onTap,
}) {

  return GestureDetector(

    onTap: onTap,

    child: AnimatedContainer(

      duration:
          const Duration(milliseconds: 180),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(

        gradient:
            active
                ? const LinearGradient(
                    colors: [
                      Color(0xFF6C63FF),
                      Color(0xFF8E7CFF),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.45),
                      Colors.white.withOpacity(0.25),
                    ],
                  ),

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color:
              active
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.5),
        ),

        boxShadow: [

          if (active)
            BoxShadow(
              color:
                  const Color(
                    0xFF6C63FF,
                  ).withOpacity(0.18),

              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          Text(
            title,

            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,

              color:
                  active
                      ? Colors.white
                      : Colors.black87,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,

            style: TextStyle(
              fontSize: 10.5,

              color:
                  active
                      ? Colors.white.withOpacity(0.85)
                      : Colors.black54,
            ),
          ),
        ],
      ),
    ),
  );
}
}

class _BottomUploadButton extends StatefulWidget {
  const _BottomUploadButton();

  @override
  State<_BottomUploadButton> createState() => _BottomUploadButtonState();
}

class _BottomUploadButtonState extends State<_BottomUploadButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => isPressed = true);
          },
          onTapUp: (_) {
            setState(() => isPressed = false);
          },
          onTapCancel: () {
            setState(() => isPressed = false);
          },

          /// 🔥 ONLY THIS WRAPPER ADDED
          child: AnimatedContainer(
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.identity()..scale(isPressed ? 0.90 : 1.0),

            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap:
                  (context.watch<UploadProvider>().isUploading)
                      // (context.watch<UploadProvider>().isUploaded)
                  ? null
                  : () async {
                      HapticFeedback.vibrate();
                      setState(() => isPressed = true);

                      Future.delayed(const Duration(milliseconds: 100), () {
                      if (mounted) setState(() => isPressed = false);
                      });

                      final provider = context.read<UploadProvider>();
                      if (provider.isUploaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutScreen(
                fileName: provider.fileName ?? "file.pdf",
                fileUrl: provider.fileUrl ?? "",
                pages: provider.pages!,
                copies: provider.copies,
                isColor: provider.isColor,
                price: provider.price,
                breakdown: provider.priceBreakdown!,
                paperSize: provider.paperSize,
                isDoubleSide: provider.isDoubleSide,
              ),
            ),
          );
          return;
        }
                      if (provider.uploadError != null) {
                        provider.clearError();
                        provider.setProgress(0);
                      }

                      if (provider.file == null) {
                    AppMessage.show(
  context,
  "Please select a file before uploading",
  type: MessageType.warning,
);
                        return;
                      }

                      if (provider.pages == null) {
AppMessage.show(
  context,
  "Please wait! Detecting total pages...",
  type: MessageType.warning,
);
                        return;
                      }

                    if (provider.pages == 0) {
  provider.removeFile();
  AppMessage.show(
    context,
    "Invalid PDF file selected",
    type: MessageType.error,
  );
  return;
}

                      provider.setUploading(true);
                      provider.setProgress(0);

                      /// 🔥 SIMULATED PROGRESS LOOP
                      Future.doWhile(() async {
                        await Future.delayed(const Duration(milliseconds: 120));

                        if (!provider.isUploading) return false;

                        if (provider.uploadProgress < 90) {
                          provider.setProgress(provider.uploadProgress + 4);
                          return true;
                        }

                        return false;
                      });
                      provider.clearError();
                      try {
                        final firebaseUser = FirebaseAuth.instance.currentUser;

                        /// 🔴 CHECK LOGIN
                        if (firebaseUser == null) {
                          AppMessage.show(
  context,
  "Please Login first before uploading",
  type: MessageType.warning,
);
                          return;
                        }

                        /// 🔹 EXTRACT USER DATA (USE SAME OBJECT EVERYWHERE)
                        final userId = firebaseUser.uid;
                        // final userName = firebaseUser.displayName ?? "User";
                        // final userEmail = firebaseUser.email ?? "";

                        /// 🔹 UPLOAD FILE
                        final result = await SupabaseStorageService.uploadPdf(
                          provider.file!,
                          userId,
                        );

                        if (result == null) throw Exception();

                        provider.setUploadResult(
                          result['url']!,
                          result['path']!,
                        );

                        /// 🔥 TRACK TEMP UPLOAD

await SupabaseService.client

    .from('temp_uploads')

    .insert({

  'user_id': userId,

  'file_path': result['path'],

  'expires_at':

      DateTime.now()
           .toUtc()

          .add(
            const Duration(
              hours: 6,
            ),
          )

          .toIso8601String(),
});

          

                        AppMessage.show(
                      context,
                       "Upload Success",
                          type: MessageType.success,
                        );
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CheckoutScreen(
      fileName: provider.fileName ?? "file.pdf",
      fileUrl: result['url']!,
      pages: provider.pages!,
      copies: provider.copies,
      isColor: provider.isColor,
      price: provider.price,
      paperSize: provider.paperSize,
      isDoubleSide: provider.isDoubleSide,
      breakdown: provider.priceBreakdown!,
    ),
  ),
);

                      } catch (e) {
                        print("ERROR 👉 $e");
                        provider.setError("Upload failed. Tap to retry.");
                        AppMessage.show(
  context,
  "Upload Failed",
  type: MessageType.error,
);
                      } finally {
                        provider.setUploading(false);
                      }
      },
              child: Container(
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 186, 175, 239),
                      Color.fromARGB(255, 181, 97, 179),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),

                  /// SAME SHADOW (kept, just slightly adjusted for visibility)
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(10, 20), // 👈 visible movement
                    ),
                  ],
                ),
                child: Consumer<UploadProvider>(
                  builder: (context, provider, _) {
                    /// 🔥 UPLOADING STATE
                    if (provider.isUploading) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Uploading ${provider.uploadProgress.toInt()}%",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// 🔥 MODERN PROGRESS BAR
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: provider.uploadProgress / 100,
                              minHeight: 5,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    if (provider.uploadError != null) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Retry Upload",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    }

                    /// 🔥 AFTER UPLOAD
                    if (provider.isUploaded) {
                      return const Text(
                        "Continue 🖨️...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }

                    /// 🔥 DEFAULT
                    return const Text(
                      "Upload Now",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 237, 223, 241),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
