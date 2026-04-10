enum CulturalCategory { classicalArt, classicalDance }

extension CulturalCategoryX on CulturalCategory {
  String get dbValue => switch (this) {
    CulturalCategory.classicalArt => 'classical_art',
    CulturalCategory.classicalDance => 'classical_dance',
  };

  String get heroLabel => switch (this) {
    CulturalCategory.classicalArt => 'Indian classical artforms',
    CulturalCategory.classicalDance => 'Indian classical dances',
  };

  String get mapTitle => switch (this) {
    CulturalCategory.classicalArt => 'Classical artforms by state',
    CulturalCategory.classicalDance => 'Classical dances by state',
  };

  String get itemTypeLabel => switch (this) {
    CulturalCategory.classicalArt => 'Artform',
    CulturalCategory.classicalDance => 'Dance',
  };
}
