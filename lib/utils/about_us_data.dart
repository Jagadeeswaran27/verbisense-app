import 'package:flutter/material.dart';
import 'package:verbisense/model/current_capabilities_model.dart';
import 'package:verbisense/model/future_enhancements_model.dart';
import 'package:verbisense/resources/strings.dart';

final List<CurrentCapabilitiesModel> currentCapabilites = [
  CurrentCapabilitiesModel(
    title: Strings.textDocuments,
    description: Strings.textDocumentDescription,
    icon: Icons.description_outlined,
  ),
  CurrentCapabilitiesModel(
    title: Strings.videoAnalysis,
    description: Strings.inDepthVedioAnalysisDescription,
    icon: Icons.videocam_outlined,
  ),
  CurrentCapabilitiesModel(
    title: Strings.audioTranscription,
    description: Strings.audioTranscriptionDescription,
    icon: Icons.headphones_outlined,
  ),
  CurrentCapabilitiesModel(
    title: Strings.imageProcessing,
    description: Strings.imageProcessingDescription,
    icon: Icons.image_outlined,
  ),
  CurrentCapabilitiesModel(
    title: Strings.contextualResponses,
    description: Strings.contextualResponsesDescription,
    icon: Icons.electric_bolt_outlined,
  ),
];

final List<FutureEnhancementsModel> futureEnhancements = [
  FutureEnhancementsModel(
    title: Strings.advancedImageRecognition,
    description: Strings.advancedImageRecognitionDescription,
    icon: Icons.remove_red_eye_outlined,
  ),
  FutureEnhancementsModel(
    title: Strings.inDepthVedioAnalysis,
    description: Strings.inDepthVedioAnalysisDescription,
    icon: Icons.local_movies_sharp,
  ),
];
