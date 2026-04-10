import 'package:myitihas/pages/map2/indian_fabrics/fabric_hub.dart';

/// Fixed UUIDs for forum scoping (must match RFC-4122 format for Postgres UUID).
const List<FabricHub> kAllFabricHubs = [
  FabricHub(
    id: 'kanchipuram_silk',
    slug: 'kanchipuram-silk',
    name: 'Kanchipuram',
    latitude: 12.8342,
    longitude: 79.7036,
    region: 'Tamil Nadu',
    fabricName: 'Kanchipuram silk',
    shortDescription:
        'Temple town famed for heavy mulberry-silk saris with zari borders.',
    aboutPlaceAndFabric:
        'Kanchipuram has woven silk for centuries; local “Kanjivaram” saris use '
        'pure mulberry silk and contrasting borders, often tied to temple motifs '
        'and seasonal colours. The cluster is supported by Tamil Nadu handloom bodies '
        'and cooperative showrooms.',
    history:
        'Kanchipuram weaving expanded under temple-economy patronage and family-led '
        'loom guilds. Its ceremonial silk identity grew through wedding and festival '
        'demand across South India.',
    culturalSignificance:
        'Kanchipuram silk is associated with bridal and ritual wardrobes, and is often '
        'considered a long-term heirloom textile in many households.',
    weavingProcess:
        'Weavers prepare mulberry yarn, align contrasting borders and body sections, '
        'and integrate zari with high thread discipline on pit looms.',
    motifsAndDesign:
        'Classic design grammar includes temple-border geometry, checks, stripes, and '
        'contrasting pallus with structured symmetry.',
    careAndAuthenticity:
        'Check zari quality, weave density, and finishing consistency from trusted '
        'cooperative/government channels. Prefer careful storage and professional cleaning.',
    bestBuyingSeason: 'October-February',
    discussionSiteId: '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a01',
    imageUrl: null,
    sellers: [
      FabricSeller(
        name: 'Tamil Nadu Handloom Development Corporation',
        organization: 'State handloom corporation (TNHDC) outlets',
        contactLine:
            'Check official TN handloom / HDC channels for emporium locations',
        website: 'tnhhandlooms.in',
        city: 'Chennai',
        sellerType: 'government',
        isFeatured: true,
      ),
      FabricSeller(
        name: 'Co-optex (Tamil Nadu Handloom Weavers’ Co-operative)',
        organization: 'Government-linked retail network',
        contactLine: 'cooptex.com — all-India outlets and online catalog',
        website: 'cooptex.gov.in',
        city: 'Kanchipuram',
        sellerType: 'cooperative',
        isFeatured: true,
      ),
    ],
  ),
  FabricHub(
    id: 'banarasi_silk',
    slug: 'banarasi-silk',
    name: 'Varanasi',
    latitude: 25.3176,
    longitude: 82.9739,
    region: 'Uttar Pradesh',
    fabricName: 'Banarasi silk',
    shortDescription:
        'Brocade weaving with gold and silver zari, used for bridal and festive saris.',
    aboutPlaceAndFabric:
        'Varanasi’s looms produce fine silk and brocade with floral and jali patterns. '
        'Banarasi work is GI-linked; many weavers sell through state emporia and '
        'UP handloom fairs alongside private showrooms along the Ganges ghats.',
    history:
        'Banarasi weaving evolved through drawloom and brocade traditions supported by '
        'artisan communities and long-distance textile trade routes.',
    culturalSignificance:
        'Banarasi silk is a premium ceremonial fabric and remains central to wedding '
        'trousseau traditions in many regions.',
    weavingProcess:
        'Production involves loom setup, jacquard card alignment, zari integration, '
        'and dense brocade weaving for motif clarity.',
    motifsAndDesign:
        'Jangla florals, bel patterns, jaal layouts, and ornate borders are signature '
        'features of Banarasi repertoire.',
    careAndAuthenticity:
        'Verify GI-linked sourcing, check reverse-side finishing, and compare zari quality '
        'before purchase from authorized channels.',
    bestBuyingSeason: 'November-March',
    discussionSiteId: '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a02',
    imageUrl: null,
    sellers: [
      FabricSeller(
        name: 'UP Handloom & Textile Department outlets',
        organization: 'State emporia (e.g. Vishwanath / state craft complexes)',
        contactLine:
            'Visit official UP handloom / tourism craft outlet listings',
        website: 'uphandloom.gov.in',
        city: 'Varanasi',
        sellerType: 'government',
        isFeatured: true,
      ),
      FabricSeller(
        name: 'India Handloom Brand (MIB) retail partners',
        organization: 'Central scheme retail — verify authorized stores',
        contactLine: 'See handloom.gov.in / India Handloom Brand listings',
        website: 'handlooms.nic.in',
        city: 'Varanasi',
        sellerType: 'verified',
      ),
    ],
  ),
  FabricHub(
    id: 'bhagalpur_tussar',
    slug: 'bhagalpur-tussar',
    name: 'Bhagalpur',
    latitude: 25.25,
    longitude: 87.0,
    region: 'Bihar',
    fabricName: 'Bhagalpuri (Tussar) silk',
    shortDescription:
        'Tussar (wild silk) with natural sheen, often in earthy tones and prints.',
    aboutPlaceAndFabric:
        'Bhagalpur is a major tussar-reeling and weaving belt; yarns are sourced from '
        'forest-based sericulture. Government schemes and Bihar handloom institutions '
        'promote GI-tagged Bhagalpuri silk through emporia and melas.',
    history:
        'Bhagalpur’s silk economy developed around river-linked trade and regional tussar '
        'sericulture ecosystems, with weaving households sustaining production lines.',
    culturalSignificance:
        'Bhagalpuri silk is preferred for breathable formal wear and contemporary Indian '
        'ethnic apparel in warmer climates.',
    weavingProcess:
        'Wild silk yarn is reeled, spun, and woven with finishing steps that preserve '
        'its natural texture and matte sheen.',
    motifsAndDesign:
        'Common visual styles include earthy tones, subtle stripes, and minimal motif '
        'language suitable for modern styling.',
    careAndAuthenticity:
        'Confirm tussar composition and weave finish from recognized state or cooperative '
        'channels before purchase.',
    bestBuyingSeason: 'September-February',
    discussionSiteId: '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a03',
    imageUrl: null,
    sellers: [
      FabricSeller(
        name: 'Bihar State Handloom & Handicrafts Development Corp.',
        organization: 'State emporium network',
        contactLine: 'Patna / regional UMS outlets — check BSHHDCL updates',
        website: 'state.bihar.gov.in/industries',
        city: 'Patna',
        sellerType: 'government',
      ),
      FabricSeller(
        name: 'Central Cottage Industries / state craft emporia',
        organization: 'Emporia stocking Bhagalpuri lots',
        contactLine: 'CCIC outlets in major cities — verify stock by season',
        website: 'cottagesemporium.in',
        city: 'New Delhi',
        sellerType: 'verified',
      ),
    ],
  ),
  FabricHub(
    id: 'pochampally_ikat',
    slug: 'pochampally-ikat',
    name: 'Pochampally',
    latitude: 17.52,
    longitude: 78.75,
    region: 'Telangana',
    fabricName: 'Pochampally Ikat',
    shortDescription:
        'Tie-and-dye warp/weft (ikat) patterns in silk and cotton — geometric clarity.',
    aboutPlaceAndFabric:
        'The Pochampally cluster near Hyderabad is known for double ikat and hybrid '
        'layouts on silk and cotton-silk. Telangana handloom federations and GI '
        'tagging help buyers find authentic yardage through society-run stores.',
    history:
        'Pochampally weaving scaled through cooperative participation and GI-based '
        'identity strengthening across domestic and export markets.',
    culturalSignificance:
        'Ikat textiles from Pochampally represent design precision and are widely used '
        'for festive attire, formal drapes, and curated designer collections.',
    weavingProcess:
        'Yarn is tied, resist-dyed, and carefully aligned in warp/weft to achieve sharp '
        'geometric forms in the final fabric.',
    motifsAndDesign:
        'Diamonds, rhythmic grids, and directional geometry define Pochampally aesthetics.',
    careAndAuthenticity:
        'Choose GI-recognized cooperative sellers and verify dye and edge finishing quality.',
    bestBuyingSeason: 'October-February',
    discussionSiteId: '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a04',
    imageUrl: null,
    sellers: [
      FabricSeller(
        name: 'Telangana State Handloom Weavers Co-operative Society',
        organization: 'State co-operative retail',
        contactLine: 'Hyderabad / Secunderabad showrooms — TSCO channels',
        website: 'telanganahandlooms.gov.in',
        city: 'Hyderabad',
        sellerType: 'cooperative',
        isFeatured: true,
      ),
      FabricSeller(
        name: 'Pochampally Handloom Park / society outlets',
        organization: 'Cluster-supported retail',
        contactLine: 'Local society shops in Pochampally village area',
        website: 'pochampallyikat.in',
        city: 'Pochampally',
        sellerType: 'verified',
      ),
    ],
  ),
  FabricHub(
    id: 'surat_textiles',
    slug: 'surat-textiles',
    name: 'Surat',
    latitude: 21.1702,
    longitude: 72.8311,
    region: 'Gujarat',
    fabricName: 'Surat textiles & traditional trade',
    shortDescription:
        'Historic wholesale hub for fabrics; strong in synthetic blends, prints, and saris.',
    aboutPlaceAndFabric:
        'Surat’s markets historically supplied dyed and printed cloth across India. '
        'Today it remains a major manufacturing and trading centre; for traditional '
        'craft authenticity, buyers often cross-check with state emporia and GI-tagged '
        'handloom sources alongside Surat trade labels.',
    history:
        'Surat evolved from a historic mercantile textile city into one of India’s most '
        'important manufacturing and wholesale distribution clusters.',
    culturalSignificance:
        'Its scale influences pan-India apparel supply chains and festive saree markets, '
        'while buyers often pair Surat sourcing with handloom verification channels.',
    weavingProcess:
        'Industrial and semi-industrial workflows combine weaving, dyeing, printing, and '
        'finishing across specialized production units.',
    motifsAndDesign:
        'Printed florals, jacquard-inspired borders, and occasionwear color palettes are '
        'widely traded in Surat markets.',
    careAndAuthenticity:
        'For traditional segments, prefer state-supported channels and request clear '
        'fiber/composition disclosures before final purchase.',
    bestBuyingSeason: 'October-March',
    discussionSiteId: '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a05',
    imageUrl: null,
    sellers: [
      FabricSeller(
        name: 'Gujarat State Handloom & Handicrafts Development Corp.',
        organization: 'Gurjari / state emporia',
        contactLine:
            'Gujarat emporia in Surat & Ahmedabad — official craft retail',
        website: 'gurjari.gujarat.gov.in',
        city: 'Ahmedabad',
        sellerType: 'government',
        isFeatured: true,
      ),
      FabricSeller(
        name: 'TRIFED / state tribal & craft outlets (seasonal)',
        organization: 'Government craft fairs',
        contactLine: 'Check exhibition calendars for verified handloom stalls',
        website: 'trifed.tribal.gov.in',
        city: 'Surat',
        sellerType: 'government',
      ),
    ],
  ),
  FabricHub(
    id: 'balrampuram_handloom',
    slug: 'balrampuram-handloom',
    name: 'Balaramapuram',
    latitude: 8.4290,
    longitude: 77.0520,
    region: 'Kerala',
    fabricName: 'Balaramapuram handloom',
    shortDescription:
        'Fine cotton handloom textiles with kasavu-style ceremonial borders.',
    aboutPlaceAndFabric:
        'Balaramapuram is a historic Kerala weaving belt known for high-quality '
        'cotton mundu and set-saree weaving linked to temple and festive use.',
    history:
        'The weaving ecosystem expanded through Travancore-era patronage and '
        'household loom networks.',
    culturalSignificance:
        'Kasavu-border textiles remain central to Onam and ceremonial wardrobes.',
    weavingProcess:
        'Fine cotton yarn setup, border planning, and loom weaving with crisp finish.',
    motifsAndDesign:
        'Minimal body with elegant border structure is the dominant style grammar.',
    careAndAuthenticity:
        'Prefer cooperative channels and verify handloom certification labels.',
    bestBuyingSeason: 'October-February',
    discussionSiteId: '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a31',
    imageUrl: null,
    sellers: [
      FabricSeller(
        name: 'Hantex',
        organization: 'Kerala State Handloom Weavers Co-operative Society',
        contactLine: 'Official Kerala handloom retail network',
        website: 'hantex.org',
        city: 'Thiruvananthapuram',
        sellerType: 'cooperative',
      ),
    ],
  ),
  FabricHub(
    id: 'ilkal_saree',
    slug: 'ilkal-saree',
    name: 'Ilkal',
    latitude: 15.9600,
    longitude: 76.1300,
    region: 'Karnataka',
    fabricName: 'Ilkal saree',
    shortDescription:
        'Traditional Karnataka drape with contrast pallu and signature weave joinery.',
    aboutPlaceAndFabric:
        'Ilkal weaving is known for practical elegance and regional weaving identity '
        'that combines cotton and silk in distinctive pallu formats.',
    history:
        'Artisan communities built Ilkal through long-standing domestic weaving networks.',
    culturalSignificance:
        'Widely used in cultural functions and traditional household ceremonies.',
    weavingProcess:
        'Body, border, and pallu planning is done with disciplined handloom coordination.',
    motifsAndDesign:
        'Checks, temple-style lines, and contrast pallus are common visual signatures.',
    careAndAuthenticity:
        'Buy from trusted cooperative outlets and inspect weave edge finishing.',
    bestBuyingSeason: 'October-March',
    discussionSiteId: '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a32',
    imageUrl: null,
    sellers: [
      FabricSeller(
        name: 'Karnataka State Handloom Outlet',
        organization: 'State handloom retail channel',
        contactLine: 'Ilkal collections via state-curated handloom stores',
        website: 'karnataka.gov.in',
        city: 'Bengaluru',
        sellerType: 'government',
      ),
    ],
  ),
  FabricHub(
    id: 'kullu_shawl',
    slug: 'kullu-shawl',
    name: 'Kullu',
    latitude: 31.9600,
    longitude: 77.1100,
    region: 'Himachal Pradesh',
    fabricName: 'Kullu shawl',
    shortDescription:
        'Wool handloom shawls with geometric borders and Himalayan visual identity.',
    aboutPlaceAndFabric:
        'Kullu shawl weaving integrates mountain wool traditions with durable weaving '
        'structures for winter and ceremonial use.',
    history:
        'The tradition grew through household looms and regional cold-climate textile demand.',
    culturalSignificance:
        'Kullu shawls represent Himachali identity and are widely exchanged as heritage gifts.',
    weavingProcess:
        'Wool yarn preparation and border weaving define this handloom process.',
    motifsAndDesign:
        'Angular geometric border motifs are the most recognizable design marker.',
    careAndAuthenticity:
        'Check wool composition and choose certified state/craft channels.',
    bestBuyingSeason: 'November-February',
    discussionSiteId: '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a33',
    imageUrl: null,
    sellers: [
      FabricSeller(
        name: 'Himachal Handloom Sales Centre',
        organization: 'State handloom and handicrafts channel',
        contactLine: 'Certified Kullu wool handloom products',
        city: 'Kullu',
        sellerType: 'government',
      ),
    ],
  ),
];

FabricHub? fabricHubById(String id) {
  for (final h in kAllFabricHubs) {
    if (h.id == id) return h;
  }
  return null;
}
