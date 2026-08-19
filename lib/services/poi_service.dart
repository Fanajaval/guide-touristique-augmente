import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/poi.dart';

class PoiService {
  PoiService._();

  static final PoiService instance = PoiService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _poisRef =>
      _firestore.collection('pois');

  Future<List<Poi>> getPois() async {
    final snapshot = await _poisRef
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Poi.fromJson(doc.data()))
        .toList();
  }

  Stream<List<Poi>> getPoisStream() {
    return _poisRef
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Poi.fromJson(doc.data()))
            .toList());
  }

  Future<Poi?> getPoiById(String id) async {
    final doc = await _poisRef.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return Poi.fromJson(doc.data()!);
  }

  Future<void> addPoi(Poi poi) async {
    await _poisRef.doc(poi.id).set(poi.toJson());
  }

  Future<void> updatePoi(Poi poi) async {
    await _poisRef.doc(poi.id).update(poi.toJson());
  }

  Future<void> deletePoi(String id) async {
    await _poisRef.doc(id).delete();
  }
}
