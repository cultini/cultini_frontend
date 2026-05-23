import 'package:equatable/equatable.dart';

/// An Algerian wilaya (administrative province). Coordinates are approximate
/// centroids/capitals — enough to place a tappable marker on the map. Geometry
/// is intentionally stubbed; the tap-per-wilaya architecture is what matters.
class WilayaEntity extends Equatable {
  const WilayaEntity({
    required this.code,
    required this.nameFr,
    required this.lat,
    required this.lng,
  });

  final int code;
  final String nameFr;
  final double lat;
  final double lng;

  @override
  List<Object?> get props => [code, nameFr, lat, lng];
}

/// The 58 wilayas (post-2019 reorganisation).
const List<WilayaEntity> kAlgeriaWilayas = [
  WilayaEntity(code: 1, nameFr: 'Adrar', lat: 27.87, lng: -0.29),
  WilayaEntity(code: 2, nameFr: 'Chlef', lat: 36.17, lng: 1.33),
  WilayaEntity(code: 3, nameFr: 'Laghouat', lat: 33.80, lng: 2.86),
  WilayaEntity(code: 4, nameFr: 'Oum El Bouaghi', lat: 35.88, lng: 7.11),
  WilayaEntity(code: 5, nameFr: 'Batna', lat: 35.55, lng: 6.17),
  WilayaEntity(code: 6, nameFr: 'Béjaïa', lat: 36.75, lng: 5.07),
  WilayaEntity(code: 7, nameFr: 'Biskra', lat: 34.85, lng: 5.73),
  WilayaEntity(code: 8, nameFr: 'Béchar', lat: 31.62, lng: -2.22),
  WilayaEntity(code: 9, nameFr: 'Blida', lat: 36.47, lng: 2.83),
  WilayaEntity(code: 10, nameFr: 'Bouira', lat: 36.37, lng: 3.90),
  WilayaEntity(code: 11, nameFr: 'Tamanrasset', lat: 22.79, lng: 5.53),
  WilayaEntity(code: 12, nameFr: 'Tébessa', lat: 35.40, lng: 8.12),
  WilayaEntity(code: 13, nameFr: 'Tlemcen', lat: 34.88, lng: -1.31),
  WilayaEntity(code: 14, nameFr: 'Tiaret', lat: 35.37, lng: 1.32),
  WilayaEntity(code: 15, nameFr: 'Tizi Ouzou', lat: 36.72, lng: 4.05),
  WilayaEntity(code: 16, nameFr: 'Alger', lat: 36.75, lng: 3.06),
  WilayaEntity(code: 17, nameFr: 'Djelfa', lat: 34.67, lng: 3.26),
  WilayaEntity(code: 18, nameFr: 'Jijel', lat: 36.82, lng: 5.77),
  WilayaEntity(code: 19, nameFr: 'Sétif', lat: 36.19, lng: 5.41),
  WilayaEntity(code: 20, nameFr: 'Saïda', lat: 34.83, lng: 0.15),
  WilayaEntity(code: 21, nameFr: 'Skikda', lat: 36.88, lng: 6.91),
  WilayaEntity(code: 22, nameFr: 'Sidi Bel Abbès', lat: 35.19, lng: -0.63),
  WilayaEntity(code: 23, nameFr: 'Annaba', lat: 36.90, lng: 7.77),
  WilayaEntity(code: 24, nameFr: 'Guelma', lat: 36.46, lng: 7.43),
  WilayaEntity(code: 25, nameFr: 'Constantine', lat: 36.36, lng: 6.61),
  WilayaEntity(code: 26, nameFr: 'Médéa', lat: 36.27, lng: 2.75),
  WilayaEntity(code: 27, nameFr: 'Mostaganem', lat: 35.93, lng: 0.09),
  WilayaEntity(code: 28, nameFr: "M'Sila", lat: 35.70, lng: 4.54),
  WilayaEntity(code: 29, nameFr: 'Mascara', lat: 35.40, lng: 0.14),
  WilayaEntity(code: 30, nameFr: 'Ouargla', lat: 31.95, lng: 5.33),
  WilayaEntity(code: 31, nameFr: 'Oran', lat: 35.70, lng: -0.63),
  WilayaEntity(code: 32, nameFr: 'El Bayadh', lat: 33.68, lng: 1.02),
  WilayaEntity(code: 33, nameFr: 'Illizi', lat: 26.48, lng: 8.47),
  WilayaEntity(code: 34, nameFr: 'Bordj Bou Arréridj', lat: 36.07, lng: 4.76),
  WilayaEntity(code: 35, nameFr: 'Boumerdès', lat: 36.77, lng: 3.48),
  WilayaEntity(code: 36, nameFr: 'El Tarf', lat: 36.77, lng: 8.31),
  WilayaEntity(code: 37, nameFr: 'Tindouf', lat: 27.67, lng: -8.15),
  WilayaEntity(code: 38, nameFr: 'Tissemsilt', lat: 35.61, lng: 1.81),
  WilayaEntity(code: 39, nameFr: 'El Oued', lat: 33.37, lng: 6.85),
  WilayaEntity(code: 40, nameFr: 'Khenchela', lat: 35.43, lng: 7.14),
  WilayaEntity(code: 41, nameFr: 'Souk Ahras', lat: 36.29, lng: 7.95),
  WilayaEntity(code: 42, nameFr: 'Tipaza', lat: 36.59, lng: 2.45),
  WilayaEntity(code: 43, nameFr: 'Mila', lat: 36.45, lng: 6.26),
  WilayaEntity(code: 44, nameFr: 'Aïn Defla', lat: 36.26, lng: 1.97),
  WilayaEntity(code: 45, nameFr: 'Naâma', lat: 33.27, lng: -0.31),
  WilayaEntity(code: 46, nameFr: 'Aïn Témouchent', lat: 35.30, lng: -1.14),
  WilayaEntity(code: 47, nameFr: 'Ghardaïa', lat: 32.49, lng: 3.67),
  WilayaEntity(code: 48, nameFr: 'Relizane', lat: 35.74, lng: 0.56),
  WilayaEntity(code: 49, nameFr: "El M'Ghair", lat: 33.95, lng: 5.92),
  WilayaEntity(code: 50, nameFr: 'El Meniaa', lat: 30.58, lng: 2.88),
  WilayaEntity(code: 51, nameFr: 'Ouled Djellal', lat: 34.42, lng: 5.07),
  WilayaEntity(code: 52, nameFr: 'Bordj Badji Mokhtar', lat: 21.32, lng: 0.95),
  WilayaEntity(code: 53, nameFr: 'Béni Abbès', lat: 30.13, lng: -2.17),
  WilayaEntity(code: 54, nameFr: 'Timimoun', lat: 29.26, lng: 0.23),
  WilayaEntity(code: 55, nameFr: 'Touggourt', lat: 33.10, lng: 6.06),
  WilayaEntity(code: 56, nameFr: 'Djanet', lat: 24.55, lng: 9.48),
  WilayaEntity(code: 57, nameFr: 'In Salah', lat: 27.19, lng: 2.48),
  WilayaEntity(code: 58, nameFr: 'In Guezzam', lat: 19.57, lng: 5.77),
];
