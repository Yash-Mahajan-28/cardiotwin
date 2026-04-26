import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class PatientRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _currentUserId => _auth.currentUser?.uid;

  /// Ensure we are saving for a specific patient.
  /// If patientId is null, falls back to the current authenticated user's ID.
  Future<void> savePatientProfile(
    PatientProfile profile, {
    String? patientId,
  }) async {
    final uid = patientId ?? _currentUserId;
    if (uid == null) throw Exception('No user authenticated');

    try {
      await _firestore.collection('users').doc(uid).update({
        'profile': profile.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      developer.log('Error saving patient profile', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Store clinical measurement evaluation
  Future<void> saveClinicalMeasurement(
    ClinicalData clinicalData, {
    String? patientId,
    String? recordId,
  }) async {
    final uid = patientId ?? _currentUserId;
    if (uid == null) throw Exception('No user authenticated');

    try {
      final collection = _firestore
          .collection('users')
          .doc(uid)
          .collection('clinical_records');
      final data = {
        'clinical_data': clinicalData.toMap(),
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (recordId != null) {
        await collection.doc(recordId).set(data, SetOptions(merge: true));
      } else {
        await collection.add(data);
      }
    } catch (e, st) {
      developer.log(
        'Error saving clinical measurement',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Store full assessment with Clinical and ECG Context
  Future<void> saveFullAssessment({
    required ClinicalData clinicalData,
    required ECGContext ecgContext,
    String? patientId,
    Map<String, dynamic>? riskResults,
  }) async {
    final uid = patientId ?? _currentUserId;
    if (uid == null) throw Exception('No user authenticated');

    try {
      final data = {
        'clinical_data': clinicalData.toMap(),
        'ecg_context': ecgContext.toMap(),
        'risk_results': riskResults,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('assessments')
          .add(data);
    } catch (e, st) {
      developer.log('Error saving full assessment', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Optional: Get all assessments for a user
  Future<List<Map<String, dynamic>>> getAssessments({String? patientId}) async {
    final uid = patientId ?? _currentUserId;
    if (uid == null) throw Exception('No user authenticated');

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('assessments')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e, st) {
      developer.log('Error getting assessments', error: e, stackTrace: st);
      return [];
    }
  }
}
