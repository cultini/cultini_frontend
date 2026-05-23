import '../../../features/docs/domain/entities/doc_entry_entity.dart';
import '../../../features/docs/data/models/doc_entry_model.dart';

/// ─── Dummy / Seed Data ───────────────────────────────────────────────────────
/// Mock data for features without a live backend (documentation corpus, adapted
/// from cultini_AI/corpus/*.json). Models carry fromJson/toJson so a remote data
/// source can replace these getters later.
class DummyData {
  DummyData._();

  // ── Documentation entries ─────────────────────────────────────────────────────
  // Mock corpus adapted from cultini_AI/corpus/*.json. No backend endpoint exists
  // yet; DocsRemoteDataSource is scaffolded for when one does.
  static List<DocEntryModel> get docEntries => [
        DocEntryModel(
          id: 'motif_yaz',
          titre: 'Le Yaz (aza)',
          categorie: DocCategory.motif,
          region: 'Afrique du Nord (usage pan-amazigh)',
          contenu:
              "Le Yaz, aussi appelé aza, est la lettre centrale de l'alphabet tifinagh "
              "devenue le symbole identitaire du peuple amazigh. Sa forme évoque un homme "
              "debout aux bras levés ; certains y voient un arbre stylisé, symbole de vie "
              "enracinée. Il figure au centre du drapeau amazigh, généralement en rouge, et "
              "se retrouve sur les bijoux, les tatouages et de nombreux objets artisanaux "
              "comme affirmation d'appartenance.",
          termesAmazighs: ['yaz', 'aza', 'tifinagh', 'Imazighen', 'amazigh'],
          source: 'Synthèse de sources de vulgarisation (Azamoul, Deena Bazaar)',
          fiabilite: 'a_verifier',
        ),
        DocEntryModel(
          id: 'motif_losange',
          titre: 'Le losange',
          categorie: DocCategory.motif,
          region: 'Batna, Ghardaïa (Aurès, Mzab)',
          contenu:
              "Le losange est l'un des motifs géométriques les plus répandus de l'art "
              "amazigh. Souvent associé à la féminité, à la fertilité et à la protection, il "
              "structure les tapis, les poteries et les tatouages. Ses variantes (losange "
              "barré, chaîne de losanges) portent des sens régionaux distincts.",
          termesAmazighs: ['talwit', 'azetta'],
          source: 'Corpus Azetta — motifs',
          fiabilite: 'a_verifier',
        ),
        DocEntryModel(
          id: 'bijou_fibule',
          titre: 'La fibule (tabzimt)',
          categorie: DocCategory.bijou,
          region: 'Tizi Ouzou (Kabylie)',
          contenu:
              "La fibule, ou tabzimt, est une broche en argent servant à fixer les vêtements "
              "féminins. Au-delà de sa fonction, elle signale le statut social et marital de "
              "celle qui la porte. Les fibules kabyles sont rehaussées d'émaux cloisonnés et "
              "de corail rouge.",
          termesAmazighs: ['tabzimt', 'tibzimin', 'lfeṭṭa'],
          source: 'Corpus Azetta — bijoux',
          fiabilite: 'a_verifier',
        ),
        DocEntryModel(
          id: 'bijou_argent_tiznit',
          titre: "L'argent de Tiznit",
          categorie: DocCategory.bijou,
          region: 'Souss (Tiznit)',
          contenu:
              "Tiznit est un centre réputé du travail de l'argent amazigh. Les artisans y "
              "produisent bracelets, colliers et khoulkhal ornés de motifs gravés et niellés. "
              "Le savoir-faire se transmet d'atelier en atelier.",
          termesAmazighs: ['azrf', 'lfeṭṭa'],
          source: 'Corpus Azetta — bijoux',
          fiabilite: 'a_verifier',
        ),
        DocEntryModel(
          id: 'bijou_emaillage',
          titre: "L'émaillage cloisonné",
          categorie: DocCategory.bijou,
          region: 'Tizi Ouzou (Beni Yenni)',
          contenu:
              "L'émaillage des Aït Yenni associe l'argent à des émaux bleu, vert et jaune et à "
              "des cabochons de corail. Cette technique distingue la bijouterie de Grande "
              "Kabylie et en fait un marqueur régional fort.",
          termesAmazighs: ['azenzar', 'lmina'],
          source: 'Corpus Azetta — bijoux',
          fiabilite: 'a_verifier',
        ),
        DocEntryModel(
          id: 'ecriture_tifinagh',
          titre: 'Le tifinagh',
          categorie: DocCategory.ecriture,
          region: 'Afrique du Nord',
          contenu:
              "Le tifinagh est l'écriture alphabétique des langues amazighes, héritière des "
              "abjads libyco-berbères antiques. Sa version moderne, le néo-tifinagh, est "
              "aujourd'hui enseignée et officialisée dans plusieurs pays.",
          termesAmazighs: ['tifinagh', 'asekkil', 'tamazight'],
          source: 'Corpus Azetta — écriture',
          fiabilite: 'a_verifier',
        ),
        DocEntryModel(
          id: 'ecriture_varietes_tamazight',
          titre: 'Les variétés du tamazight',
          categorie: DocCategory.ecriture,
          region: 'Afrique du Nord',
          contenu:
              "Le tamazight regroupe un continuum de variétés : kabyle, chaoui, mozabite, "
              "chleuh, tarifit, tamasheq… Mutuellement plus ou moins intelligibles, elles "
              "partagent un fonds lexical et grammatical commun.",
          termesAmazighs: ['taqbaylit', 'tacawit', 'tumẓabt', 'tacelḥit'],
          source: 'Corpus Azetta — écriture',
          fiabilite: 'a_verifier',
        ),
        DocEntryModel(
          id: 'technique_azetta_metier',
          titre: 'Azetta — le métier à tisser',
          categorie: DocCategory.technique,
          region: 'Béjaïa, Batna (Kabylie, Aurès)',
          contenu:
              "Azetta désigne le métier à tisser vertical et, par extension, l'art du tissage "
              "amazigh. Le montage de la chaîne, le choix des motifs et le rythme du tissage "
              "obéissent à des règles transmises entre femmes.",
          termesAmazighs: ['azetta', 'tislgit', 'asaru'],
          source: 'Corpus Azetta — techniques',
          fiabilite: 'a_verifier',
        ),
        DocEntryModel(
          id: 'technique_teintures_naturelles',
          titre: 'Les teintures naturelles',
          categorie: DocCategory.technique,
          region: 'Ghardaïa, Adrar',
          contenu:
              "Garance, indigo, henné, écorces et grenade fournissent la palette des teintures "
              "naturelles employées pour la laine. Mordançage et bains successifs donnent des "
              "rouges, bleus et ocres caractéristiques.",
          termesAmazighs: ['taroubia', 'nila', 'lḥenni'],
          source: 'Corpus Azetta — techniques',
          fiabilite: 'a_verifier',
        ),
        DocEntryModel(
          id: 'gastronomie_tagoulla',
          titre: 'Tagoulla',
          categorie: DocCategory.gastronomie,
          region: 'Tamanrasset',
          contenu:
              "La tagoulla est une bouillie épaisse de semoule d'orge servie avec de l'huile "
              "d'argan ou du beurre rance (oudi). Plat d'hiver nourrissant, elle est partagée "
              "dans un plat commun.",
          termesAmazighs: ['tagoulla', 'oudi', 'tumlilt'],
          source: 'Corpus Azetta — gastronomie',
          fiabilite: 'a_verifier',
        ),
        DocEntryModel(
          id: 'gastronomie_tafarnout',
          titre: 'Tafarnout — le pain au four de terre',
          categorie: DocCategory.gastronomie,
          region: 'Adrar, Timimoun',
          contenu:
              "Tafarnout désigne un pain plat cuit contre la paroi d'un four de terre chauffé "
              "au bois. La pâte y adhère puis se détache une fois cuite, donnant une croûte "
              "fine et fumée.",
          termesAmazighs: ['tafarnout', 'aghroum'],
          source: 'Corpus Azetta — gastronomie',
          fiabilite: 'a_verifier',
        ),
      ];
}
