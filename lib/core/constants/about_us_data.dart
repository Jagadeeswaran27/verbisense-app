import 'package:flutter/material.dart';

import 'package:verbisense/core/entities/about_us_model.dart';
import 'package:verbisense/core/resources/strings/common_strings.dart';

final List<AboutUsModel> currentCapabilites = [
  AboutUsModel(
    title: CommonStrings.textDocuments,
    description: CommonStrings.textDocumentDescription,
    icon: Icons.description_outlined,
  ),
  AboutUsModel(
    title: CommonStrings.videoAnalysis,
    description: CommonStrings.inDepthVedioAnalysisDescription,
    icon: Icons.videocam_outlined,
  ),
  AboutUsModel(
    title: CommonStrings.audioTranscription,
    description: CommonStrings.audioTranscriptionDescription,
    icon: Icons.headphones_outlined,
  ),
  AboutUsModel(
    title: CommonStrings.imageProcessing,
    description: CommonStrings.imageProcessingDescription,
    icon: Icons.image_outlined,
  ),
  AboutUsModel(
    title: CommonStrings.contextualResponses,
    description: CommonStrings.contextualResponsesDescription,
    icon: Icons.electric_bolt_outlined,
  ),
];

final List<AboutUsModel> futureEnhancements = [
  AboutUsModel(
    title: CommonStrings.advancedImageRecognition,
    description: CommonStrings.advancedImageRecognitionDescription,
    icon: Icons.remove_red_eye_outlined,
  ),
  AboutUsModel(
    title: CommonStrings.inDepthVedioAnalysis,
    description: CommonStrings.inDepthVedioAnalysisDescription,
    icon: Icons.local_movies_sharp,
  ),
];
