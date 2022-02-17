import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  //en,fr,es,de
  static var _t = Translations("en") +
      {
        "en": "Description",
        "fr": "Description",
        "es": "Descripción",
        "de": "Beschreibung",
        "pt": "Descrição",
        "ar": "وصف",
        "ko": "기술"
      } +
      {
        "en": "Address",
        "fr": "Adresse",
        "es": "Dirección",
        "de": "Adresse",
        "pt": "Endereço",
        "ar": "تبوك",
        "ko": "주소"
      } +
      {
        "en": "Phone",
        "fr": "Téléphone",
        "es": "Teléfono",
        "de": "Telefon",
        "pt": "Telefone",
        "ar": "هاتف",
        "ko": "전화"
      } +
      {
        "en": "Upload Prescription",
        "fr": "Télécharger l'ordonnance",
        "es": "Subir prescripción",
        "de": "Rezept hochladen",
        "pt": "Fazer upload de prescrição",
        "ar": "تحميل الوصفة الطبية",
        "ko": "처방전 업로드"
      } +
      {
        "en": "PLACE ORDER REQUEST",
        "fr": "PASSEZ UNE DEMANDE DE COMMANDE",
        "es": "REALIZAR SOLICITUD DE PEDIDO",
        "de": "BESTELLANFRAGE AUFGEBEN",
        "pt": "FAZER PEDIDO DE PEDIDO",
        "ar": "تقديم طلب",
        "ko": "주문 요청"
      } +
      {
        "en": "Note",
        "fr": "Noter",
        "es": "Nota",
        "de": "Hinweis",
        "pt": "Observação",
        "ar": "ملحوظة",
        "ko": "노트"
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
