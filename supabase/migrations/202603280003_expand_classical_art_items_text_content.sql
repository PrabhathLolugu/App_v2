-- Expand narrative fields for Indian classical artforms (cultural_state_items
-- where hub category = classical_art). Does NOT touch cover_image_url or gallery_urls.

-- Andhra Pradesh — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Kalamkari: vegetable-dyed narrative painting and resist block-print on cloth, named for the kalam (pen)—two major streams, Srikalahasti (hand-drawn temple episodes) and Machilipatnam (mordant block-print export idiom).',
  about_state_tradition = 'Andhra Pradesh hosts both pen Kalamkari—where artists draw Ramayana, Mahabharata, and Puranic cycles directly on cotton—and the Coromandel Coast tradename Machilipatnam Kalamkari shaped by Persian market tastes and later European trade. Natural dyes (indigo, madder, pomegranate skin, iron black) and repeated washing produce characteristic earth tones. The form lives in hereditary families, craft corporations, and design institutes that connect temple patrons to global fashion.',
  history = 'Medieval temple chariot canopies and pilgrim souvenirs fed early demand; Golconda and British-period trade standardized some repeat blocks. UNESCO and GI discourse now frame Kalamkari alongside revival projects that balance natural dye chemistry with volume orders.',
  cultural_significance = 'Kalamkari encodes scripture for lay viewers, dresses deities and processions, and signals Andhra craft identity in diaspora markets. It bridges fine art, textile, and pedagogic storytelling.',
  practice_and_pedagogy = 'Learners master mordant sequence, kalam pressure for line weight, block registration, and colour-fast finishing. Master–apprentice households remain core; short courses add design graduates who adapt motifs to interiors and apparel.',
  performance_context = 'Temple festivals, craft melas, biennales, museum shops, and high-fashion collaborations; Srikalahasti pieces often commissioned for specific narrative panels.',
  notable_exponents = 'Srikalahasti and Machilipatnam master families; Andhra Pradesh Crafts Development Corporation; National Institute of Design collaborations.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-AP' AND i.item_name = 'Kalamkari Visual Tradition';

-- Arunachal Pradesh
UPDATE public.cultural_state_items i SET
  short_description = 'Monpa thangka: Tibetan Buddhist scroll painting on cotton or silk, governed by iconometric grids—deities, mandalas, and lineage masters for ritual viewing and monastic instruction.',
  about_state_tradition = 'Western Arunachal Pradesh (Tawang, Dirang) shares Tibetan Vajrayana visual culture: thangkas are not decorative alone but mnemonic devices for initiation, meditation, and merit. Mineral pigments, gold wash, and precise line follow canonical proportions (tikse) transmitted orally and through pattern books.',
  history = 'Monastic networks from Tibet and Bhutan shaped local ateliers; contemporary workshops train young painters while serving tourism and dharma centres.',
  cultural_significance = 'Thangkas consecrate space, travel with lamas, and document lineage. They anchor Monpa identity within Himalayan Buddhism.',
  practice_and_pedagogy = 'Years of copying under a lama-artist; ground preparation, charcoal underdrawing, colour layering from distant to near, opening the eyes (dri-bris) as final life-giving stroke.',
  performance_context = 'Gompas, lhakhangs, museums, and international dharma centres; large appliqué thangkas unveiled at some festivals.',
  notable_exponents = 'Tawang monastery workshop painters; Dirang heritage ateliers; Sangeet Natak Akademi–recognized masters.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-AR' AND i.item_name = 'Monpa Thangka Tradition';

-- Assam — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Majuli satra masks: three-dimensional bamboo–clay–fabric masks for Ankiya Bhaona—Sattriya theatre''s visual embodiment of Rama, Ravana, Hanuman, and folk spirits.',
  about_state_tradition = 'Vaishnavite satras (monasteries) on Majuli island and elsewhere commission masks that combine sculptural volume with danceable weight. Colours encode character: green for nobility, black for demons (with nuance), white for aged sages. Mask-making is inseparable from choreography and percussion.',
  history = 'Sankardeva and Madhavdeva''s neo-Vaishnavite reform linked narrative drama to devotion; satra workshops preserved typologies through centuries of flood and migration.',
  cultural_significance = 'UNESCO-listed Sattriya dance depends on these masks; they are living ritual objects, not mere props.',
  practice_and_pedagogy = 'Bamboo armature, clay layering, cloth skin, natural and acrylic pigments; apprentices learn iconography from satradhikar guidance and performance needs.',
  performance_context = 'Bhaona nights, Sattriya festivals, state-sponsored cultural tours, documentation by INTACH and museums.',
  notable_exponents = 'Majuli satra artisan families; Sangeet Natak Akademi awardees in mask craft.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-AS' AND i.item_name = 'Majuli Mask Craft Theatre Art';

-- Bihar — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Madhubani (Mithila painting): brilliant natural and pigment-filled compositions of gods, weddings, flora, and social commentary—traditionally women''s wall art, now paper, cloth, and canvas.',
  about_state_tradition = 'The Mithila region (north Bihar, parts of Nepal) uses kohbar ghar bridal chambers, kohbar scrolls, and seasonal aripan floor diagrams. Double-outline (kachni) and colour-fill (bharni) styles coexist; some lineages specialize in tantric yantras or Ganga scenes.',
  history = 'All-India exposure began with 1934 earthquake documentation and 1960s craft marketing; women''s cooperatives (e.g. Jitwarpur) and male artists expanded the canon. GI tag (2007) names Bihar Mithila painting.',
  cultural_significance = 'Encodes women''s ritual knowledge, caste-specific sub-styles, and ecological motifs (fish, lotus, peacock). Global folk-art market icon.',
  practice_and_pedagogy = 'Bamboo nib, cotton rag brushes, natural black from soot, turmeric, indigo, lac; composition taught through family grids and story repetition.',
  performance_context = 'Craft fairs, Mithila museums, airport galleries, UNICEF and design collaborations.',
  notable_exponents = 'Sita Devi, Ganga Devi, Mahasundari Devi lineages; contemporary artists in Darbhanga and Madhubani districts.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-BR' AND i.item_name = 'Madhubani Painting';

-- Chhattisgarh — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Bastar Dhokra: non-ferrous metal casting by lost wax (cire perdue)—beeswax–resin core, clay mould, brass or bell-metal pour—yielding ritual horses, tribal deities, and utilitarian vessels.',
  about_state_tradition = 'Gharua, Jharha, and related communities in Kondagaon, Jagdalpur, and surrounding blocks work in household foundries. Each piece is unique because the wax original is destroyed; surface shows characteristic roughness (“golden fleece” texture).',
  history = 'Archaeological parallels to Mohenjo-daro ''dancing girl'' narrative popularized dhokra antiquity; modern markets mix ancestor shrines, tourist demand, and export.',
  cultural_significance = 'Links tribal cosmology, bride-price objects, and village shrines; symbol of Chhattisgarh in state handicraft policy.',
  practice_and_pedagogy = 'Clay core, wax thread modelling, drain ducts, firing, pouring, cooling, finishing; sons often learn by assisting fathers at furnace.',
  performance_context = 'Haat bazaars, state emporia, Dussehra fairs of Bastar, international craft orders.',
  notable_exponents = 'National awardees in Kondagaon cluster; cooperative societies.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-CT' AND i.item_name = 'Bastar Dhokra Sculpture';

-- Goa
UPDATE public.cultural_state_items i SET
  short_description = 'Mando: Luso-Konkani song form whose staged presentation layers velvet gowns, parasols, and melancholic love lyrics—visual culture of Goan Catholic elite blended with Konkani poetics.',
  about_state_tradition = 'Nineteenth-century parlour and club performance created a recognizable costume grammar: Victorian silhouettes, fan gestures, and ensemble seating. Mando is listed among Goan ICH alongside other genres; visual documentation preserves jewellery and coiffure norms.',
  history = 'Portuguese colonial society, print culture, and twentieth-century revivalists (e.g. Menezes Braganza) shaped canon; audio archives now pair with costume museums.',
  cultural_significance = 'Expresses Goan syncretism—Konkani language, European harmony, Indian melodic turns—and gendered performance etiquette.',
  practice_and_pedagogy = 'Music schools and cultural academies teach ghumot percussion, violin obbligato, and stage deportment; costume often family heirlooms.',
  performance_context = 'Christmas concerts, Goa Art and Literature Festival, DD archives, diaspora associations.',
  notable_exponents = 'Traditional Mando groups; Kala Academy ensembles.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-GA' AND i.item_name = 'Mando Music-Theatre Visual Art';

-- Gujarat — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Pithora: large-scale ritual wall painting by Rathwa and Bhilala communities—horses, ancestors, Pithora Baba, and cosmograms invoked for vows, healing, and harvest.',
  about_state_tradition = 'Executed on inner walls of huts with chalk, charcoal, and natural pigments; a badvo (shaman) often presides while painters work in ritual time. Horses march in rows as auspicious vehicles for vows fulfilled.',
  history = 'Anthropologists and tribal museums (e.g. Chhota Udaipur) documented grammar; contemporary art biennales quote Pithora aesthetics.',
  cultural_significance = 'Legal–spiritual contract with deities made visible; community memory of migration and clan.',
  practice_and_pedagogy = 'Apprentices learn motif order (not free composition), pigment grinding, and vow protocols before brush independence.',
  performance_context = 'Village shrines, Adivasi art residencies, Tribal Museum Ahmedabad displays.',
  notable_exponents = 'Rathwa painter families in Panchmahals; documented badvo-painter pairs.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-GJ' AND i.item_name = 'Pithora Ritual Painting';

-- Haryana
UPDATE public.cultural_state_items i SET
  short_description = 'Phulkari: literally ''flower work''—dense silk or untwisted floss embroidery on hand-spun cotton (khaddar), historically bridal baghs (gardens) covering entire ground.',
  about_state_tradition = 'Haryana and Punjab share phulkari vocabulary; in Haryana, motifs include kikar (acacia), peacock, and geometric chope patterns. Red, orange, and gold on rust ground dominate wedding pieces; black for mourning variants exists.',
  history = 'Pre-Partition women''s collective time produced phulkaris for dowry; Partition archives preserve museum pieces. Revival through NGOs and fashion designers reintroduced darn stitch (herringbone) density.',
  cultural_significance = 'Embodies women''s kinship networks, lifecycle gifting, and regional pride; UNESCO ICH nomination discourse includes phulkari.',
  practice_and_pedagogy = 'Counting threads for symmetry; stitch direction hides knots; contemporary workshops teach pattern transfer and colour planning.',
  performance_context = 'Surajkund Mela, state emporia, wedding trousseaus, global South Asian fashion weeks.',
  notable_exponents = 'Chamba and Panipat revival centres; award-winning women cooperatives.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-HR' AND i.item_name = 'Phulkari Heritage Embroidery Art';

-- Himachal Pradesh — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Kangra miniature: late Pahari school famed for lyrical naturalism—slender figures, delicate foliage, and Nayika themes in Rajput–Mughal fusion palette.',
  about_state_tradition = 'Guler, Kangra, and related courts under Rajput rulers patronized artists who moved from Basohli intensity to pastel romanticism. Ragamala, Baramasa, and Krishna–Radha series are canonical.',
  history = 'Nainsukh and Manaku lineages anchor art history; museums worldwide hold Kangra works. Contemporary miniaturists work in Chamba, Dharamshala, and Mandi at scaled formats.',
  cultural_significance = 'Defines Himachal''s contribution to Indian painting alongside Chamba rumal; influences poster art and calendar aesthetics.',
  practice_and_pedagogy = 'Squirrel-hair brushes, stone colours, wasli paper preparation, underdrawing, wash layering, facial modelling in three-quarter light.',
  performance_context = 'National Museum Delhi, Himachal State Museum, art fairs, export to collectors.',
  notable_exponents = 'Pandit Shiv Charan Sharma lineage; contemporary Pahari revivalists.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-HP' AND i.item_name = 'Kangra Miniature Painting';

-- Jharkhand — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Sohrai (harvest) and Khovar (bridal) murals: women''s finger, combs, and twig tools apply earth reds, blacks, and whites on damp cow-dung plaster—botanical, fertility, and animal vocabularies.',
  about_state_tradition = 'Hazaribagh plateau villages paint during Sohrai cattle festival and Khovar marriage chambers. Motifs include fertility trees, forest life, and lunar symbols; UNESCO ICH listing (2021) recognizes Sohrai-Khovar mural tradition.',
  history = 'Tribal and agrarian calendars structure painting windows; NGOs and INTACH document walls before monsoon loss.',
  cultural_significance = 'Women''s public art claiming architectural surfaces; ecological symbolism in adivasi cosmovision.',
  practice_and_pedagogy = 'Red ochre (imli), manganese black, kaolin white; comb dragged through wet pigment; knowledge transmitted mother-to-daughter.',
  performance_context = 'Village homes, Tribal Research Institute exhibitions, India Art Fair folk sections.',
  notable_exponents = 'Hazaribagh women artist communities; documented villages like Jorakath.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-JH' AND i.item_name = 'Sohrai-Khovar Wall Art';

-- Karnataka — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Mysore painting: gessoed board or paper with gold leaf, agate burnishing, and precise devotional icons—Shiva, Vishnu, Lakshmi, and saints in jewel-toned gouache.',
  about_state_tradition = 'Wodeyar court and palace workshops standardized symmetry, ornament density, and gold relief (gesso paste). Unlike Tanjore''s heavier muk work, Mysore often favours flatter gold fields with fine line.',
  history = 'Mummadi Krishnaraja Wodeyar era consolidation; CIE Mysore exhibitions spread reputation. Cauvery crafts and palace sales sustain ateliers.',
  cultural_significance = 'Temple gifts, domestic shrines, and state ceremonial gifting; Karnataka''s classical visual brand alongside Mysore silk.',
  practice_and_pedagogy = 'Wood board, chalk-gesso layers, gold leaf adhesion, stone colours, squirrel brush detailing, eye finishing ritual.',
  performance_context = 'Dasara exhibitions, Cauvery emporia, craft melas, online masterclasses.',
  notable_exponents = 'Palace-trained masters; Mysuru Chitrakala Parishath alumni.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-KA' AND i.item_name = 'Mysore Painting';

-- Kerala — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Kathakali chutti: rice-paste facial architecture—white ridges (chutti), green hero faces (pacha), red-beard demons, and minukku tones—codified with costume and headgear (kireetam, koppu).',
  about_state_tradition = 'Makeup (chutti–vesham) is a specialist craft: artists layer cotton on cheek with paste, sculpt curves, and paint for hours before performance. Each character type has fixed colour grammar tied to Natyashastra-derived Kerala performance theory.',
  history = 'Kottayam royal and temple sponsorship crystallized repertoire; Kerala Kalamandalam professionalized training; tourism globalized backstage photos.',
  cultural_significance = 'Transforms actor into archetype; inseparable from chenda rhythm and ilakiyattam narrative gesture.',
  practice_and_pedagogy = 'Separate chutti artists train in paste consistency, skin safety, and speed; actors learn vesha maintenance during long nights.',
  performance_context = 'Temple kuttampalams, Kalamandalam, hotel cultural shows, international tours.',
  notable_exponents = 'Kalamandalam makeup lineages; Sangeet Natak Akademi honourees in vesham.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-KL' AND i.item_name = 'Kathakali Chutti Visual Design';

-- Madhya Pradesh — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Gond painting: Digna (floor) and Ladi (wall) lineage evolved into canvas art—intricate dots, lines, and colours encoding forest spirits, mahua trees, and mythic narratives.',
  about_state_tradition = 'Gond–Pardhan communities of Mandla, Dindori, and Patangarh (where Jangarh Singh Shyam catalysed global recognition) use syahi charcoal, plant sap, and acrylic in contemporary practice.',
  history = '1980s Bharat Bhavan and Gond mahapanchayat linked artists to urban galleries; biennale circuits now collect Gond alongside Australian Aboriginal dialogues.',
  cultural_significance = 'Visualizes adivasi ontology—every hill, animal, and song has a pattern; income shifts empowerment dynamics within families.',
  practice_and_pedagogy = 'Motif is “signature” of clan; young artists learn fill techniques before inventing personal variations; art camps teach scale and canvas priming.',
  performance_context = 'Kochi-Muziris Biennale, Tribal Museum Khajuraho, Japan Foundation tours.',
  notable_exponents = 'Jangarh Singh Shyam; Venkat Shyam; Bhajju Shyam; Japani Shyam.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-MP' AND i.item_name = 'Gond Narrative Art';

-- Maharashtra — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Warli: white rice-paste pigment on red ochre cow-dung walls—triangular humans, spiral tarpa dance, and nature spirits in rhythmic monochrome bands.',
  about_state_tradition = 'Palghar, Dahanu, and Nashik–Dhule Adivasi villages paint for harvest weddings and death rituals. Composition uses circle (moon/sun), spiral (energy), and square (sacred enclosure).',
  history = '1970s Mumbai artists and Gondwana Raw Earth helped commercialize on paper; UNESCO and state boards include Warli in syllabi.',
  cultural_significance = 'Anti-urban ecological message in contemporary art; authentic village walls vs. mass tourist scrolls raises ongoing debate.',
  practice_and_pedagogy = 'Bamboo chewed tip brush; pigment from rice paste and limestone; no perspective—narrative reads as rhythm not illusion.',
  performance_context = 'Village huts, Crafts Museum Delhi, fashion collaborations, airport murals.',
  notable_exponents = 'Jivya Soma Mashe; national awardee village painters in Ganjad.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-MH' AND i.item_name = 'Warli Painting';

-- Manipur
UPDATE public.cultural_state_items i SET
  short_description = 'Sankirtana: UNESCO-listed ritual performance of Manipuri Vaishnavism—paired pung (barrel drum) players, gostha singing, and tandava–lasya movement in mandapa architecture.',
  about_state_tradition = 'Performed in temple sanctum and ras mandap, sankirtana obeys strict repertoire (rasa) cycles narrating Krishna lila. Costume is white dhoti, folded turban, and minimal ornament; visual focus is choreographic geometry and drum dialogue.',
  history = 'Hinduism localized through Meitei kingship and Bengali Bhagavata influence; colonial documentation and post-independence academies codified teaching.',
  cultural_significance = 'ICH inscription (2013) recognizes community transmission; life-cycle and deity-installation rites require sankirtana.',
  practice_and_pedagogy = 'Guru–shishya in gurukul format; percussion syllables (cholom) mapped to body; years to master pung paired improvisation.',
  performance_context = 'Mandaps, Yaoshang (Holi), installation rites, international heritage festivals.',
  notable_exponents = 'Guru Amudon Sharma; Naba Kumar; Jawaharlal Nehru Manipur Dance Academy lineages.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-MN' AND i.item_name = 'Manipuri Sankirtana Performance Art';

-- Meghalaya
UPDATE public.cultural_state_items i SET
  short_description = 'Wangala: Garo harvest thanksgiving where drums (katta, wak) drive line dances in gongs, feathered turbans, and colour-blocked costumes—visual rhythm of agrarian time.',
  about_state_tradition = 'Post-harvest November festival honours Saljong (sun deity). Choreography alternates rows, circles, and spear gestures; costume includes damag (headgear) and ornamental shields in staged versions.',
  history = 'Christian conversion layered on indigenous calendar; state tourism packages Wangala for cultural diplomacy.',
  cultural_significance = 'Affirms matrilineal Garo identity and jhum-to-settled agriculture memory.',
  practice_and_pedagogy = 'Village nokma and youth dormitories train drum cycles; schools compete in Wangala choreography contests.',
  performance_context = 'Tura, Asanang fields, Republic Day tableau, Hornbill Festival crossover.',
  notable_exponents = 'Garo Hills cultural troupes; Department of Arts & Culture Meghalaya ensembles.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-ML' AND i.item_name = 'Wangala Drum-Choreographic Art';

-- Mizoram
UPDATE public.cultural_state_items i SET
  short_description = 'Cheraw (bamboo dance): dancers step between rhythmically clapped green bamboo poles—Mizo emblem of precision, taught in schools and showcased nationally.',
  about_state_tradition = 'Originally linked to agricultural rites; now highly choreographed with synchronized costumes (puanchei, kawrchei patterns) and male pole sitters in Mizo textiles.',
  history = 'Post-statehood cultural policy elevated Cheraw as state dance; Guinness attempts and tourism amplified visibility.',
  cultural_significance = 'Youth identity and collective discipline metaphor; Christian-majority state''s secular heritage emblem.',
  practice_and_pedagogy = 'Beginners learn foot patterns slowly; clappers coordinate tempo changes; safety training prevents ankle injury.',
  performance_context = 'Chapchar Kut, state day, EDU-lympics, international folk festivals.',
  notable_exponents = 'Aizawl cultural troupes; MZU performing arts students.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-MZ' AND i.item_name = 'Mizo Bamboo Performance Art';

-- Nagaland
UPDATE public.cultural_state_items i SET
  short_description = 'Naga woodcarving: morungs (bachelor dormitories), village gates, and feast trophies carry anthropomorphic and animal motifs—headhunting memory abstracted into heraldic design.',
  about_state_tradition = 'Each tribe (Angami, Ao, Konyak, etc.) varies motif vocabulary; carving marks status, clan myths, and migration routes. Christian villages repurpose skills for church pulpits and tourism.',
  history = 'Colonial photography fixed “wild headhunter” iconography; post-independence craft corporations market panels and masks.',
  cultural_significance = 'Material archive of oral history; Hornbill Festival displays compete in architectural scale.',
  practice_and_pedagogy = 'Apprenticeship with adzes and chisels; knowledge of grain direction and ritual prohibitions on certain trees.',
  performance_context = 'Morung tourism, chief angh houses, state handicraft emporia, diaspora cultural centres.',
  notable_exponents = 'Kohima and Dimapur master carvers; tribe-wise heritage committees.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-NL' AND i.item_name = 'Naga Woodcarving Heritage Art';

-- Odisha — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Pattachitra: cloth-based narrative painting of Jagannath, Krishna lila, and regional myths—fine brush on treated cloth, often with decorative floral border (pat) and natural pigments.',
  about_state_tradition = 'Raghurajpur heritage village and Puri–Chitrakar families serve temple souvenir and ritual needs; sibling craft tala-pattachitra uses palm leaf engraving. Chitrakars maintain caste–craft identity while diversifying to household items.',
  history = 'Jagannath temple seva links; GI registration (2008) for Pattachitra; international craft fairs expanded palette to acrylic while purists retain stone colours.',
  cultural_significance = 'Visual theology for pilgrims; Gotipua and Odissi costumes borrow painting motifs.',
  practice_and_pedagogy = 'Two shells for pigment; squirrel brush; gum-treated cloth; strict iconometric grids for deities.',
  performance_context = 'Raghurajpur, Ekamra Haat, temple cordons, Crafts Museum collections.',
  notable_exponents = 'National award chitrakar families in Puri and Cuttack districts.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-OR' AND i.item_name = 'Pattachitra Classical Painting';

-- Punjab — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Sikh fresco and manuscript art: wall paintings in gurdwaras and forts (Lahore–Amritsar circuit) and illustrated janamsakhis—floral frames, battle scenes, and Guru portraiture.',
  about_state_tradition = 'Maharaja Ranjit Singh-era ateliers blended Kangra faces with Sikh symbolism; surviving sites include Amritsar, Anandpur, and Pakistan Punjab. Conservation faces saltpetre and modern plaster damage.',
  history = 'From pre-modern mural saints to colonial photography; INTACH and SGPC projects train conservators in lime plaster and mineral pigments.',
  cultural_significance = 'Sacred space pedagogy; visual history for non-literate congregations in earlier centuries.',
  practice_and_pedagogy = 'Restoration chemistry, secco and fresco techniques, archival copying of manuscript shabad illumination.',
  performance_context = 'Heritage walks, Partition Museum exhibits, digital 3D documentation.',
  notable_exponents = 'Punjab University fine arts conservation unit; traditional mistry families.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-PB' AND i.item_name = 'Sikh Fresco-Miniature Heritage Art';

-- Rajasthan — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Phad: long horizontal cloth scroll (up to 30 feet) depicting Pabuji or Devnarayan epics—carried by Bhopa priests who sing and point with lamp at night performances.',
  about_state_tradition = 'Shahpura (Bhilwara) Josi families paint vermilion-dominated narratives in compartmentalized registers; indigo night sky and horses repeat. UNESCO ICH nomination discourse includes Phad.',
  history = 'Rajput patronage of folk deities sustained mobile shrines; audio recordings now supplement live phad vachan.',
  cultural_significance = 'Portable temple for Rebari herders; oral epic + painting inseparable.',
  practice_and_pedagogy = 'Vegetable colours on coarse cloth; strict iconography for hero, sword, and snake episodes; apprenticeship in Josi gharanas.',
  performance_context = 'Village jagran nights, desert festivals, craft documentation projects.',
  notable_exponents = 'Shri Lal Joshi family; National Awardee Phad painters.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-RJ' AND i.item_name = 'Phad Narrative Scroll Painting';

-- Sikkim
UPDATE public.cultural_state_items i SET
  short_description = 'Sikkimese thangka: Nyingma, Kagyu, and Sakya lineages painted in monasteries like Rumtek and Pemayangtse—Newar artisan influence meets Tibetan canons.',
  about_state_tradition = 'Bhutia and Nepali craftsmen serve Buddhist institutions; brocade mounting (Chinese silk frames) completes consecration-ready scrolls.',
  history = 'Chogyal patronage and post-1975 Indian state support for monastery restoration spurred atelier growth.',
  cultural_significance = 'Dharma propagation tool; state symbol of Himalayan pluralism.',
  practice_and_pedagogy = 'Grid (thig) drawing, mineral grind, 24k gold burnish, silk brocade sewing apprenticeships.',
  performance_context = 'Monastery shops, Namgyal Institute exhibitions, Gangtok craft bazaar.',
  notable_exponents = 'Monastic thangka departments; lay Newar painter families in Gangtok.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-SK' AND i.item_name = 'Sikkimese Thangka School';

-- Tamil Nadu — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Tanjore (Thanjavur) painting: wood panel, gesso relief, 22k gold foil, and inset glass gems framing deities—Dravidian iconometry with Baroque surface richness.',
  about_state_tradition = 'Maratha court of Thanjavur intensified gold use; Chettinad merchants spread panels across Tamil homes. Subjects: Balakrishna, Rama Pattabhishekam, composite Ganesha.',
  history = 'Company School interaction exists in margins; GI application and Cauvery marketing standardized “Tanjore” branding.',
  cultural_significance = 'Wedding and gruhapravesam gifts; temple donor plaques; Tamil Nadu''s luxury craft identity.',
  practice_and_pedagogy = 'Jackfruit wood, chalk gesso moulding, gold sheet pressing with agate burnisher, poster colours over gold.',
  performance_context = 'Thanjavur lanes, Chennai craft exhibitions, e-commerce replicas (buyer beware).',
  notable_exponents = 'Traditional Chetty and Raju artist communities; palace workshop descendants.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-TN' AND i.item_name = 'Tanjore Painting';

-- Telangana — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Cheriyal (Nakashi) scrolls: vertical painted narrative strips on khadi coated with tamarind paste and rice paste—storytellers unroll episodes of Markandeya Purana, local legends, and contemporary satire.',
  about_state_tradition = 'Cheriyal town in Jangaon district hosts Vaikuntam family and others; natural colours and bold outlines echo older leather puppet aesthetics. Scrolls functioned as mobile cinema for rural audiences.',
  history = 'GI tag (Cheriyal scroll painting); decline of wandering performers pushed sales toward décor and museums.',
  cultural_significance = 'Telangana state formation iconography; links to Yakshagana and puppet genealogies.',
  practice_and_pedagogy = 'Brush from squirrel tail; stone colours; narrative sequencing taught as grid of frames.',
  performance_context = 'Surajkund, Shilparamam, MOMA workshops, UNICEF health messaging scrolls.',
  notable_exponents = 'D. Vaikuntam family; Telangana State Awards recipients.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-TS' AND i.item_name = 'Cheriyal Scroll Painting';

-- Tripura
UPDATE public.cultural_state_items i SET
  short_description = 'Tripuri bamboo–cane craft: woven room dividers, dulla hats, fish traps, and ritual baskets with geometric twill and hex patterns—visual math of forest economy.',
  about_state_tradition = 'Reang, Jamatia, and Tripuri communities split bamboo to hair fineness; natural smoking darkens fibres. State design centres adapt motifs to furniture and lamps.',
  history = 'Royal Tripura patronage archives; post-merger Indian welfare schemes created cooperative societies.',
  cultural_significance = 'Everyday sustainability aesthetic; state tableau staple.',
  practice_and_pedagogy = 'Seasonal bamboo cutting rituals; apprenticeship in split uniformity and dye from bark.',
  performance_context = 'Poush Mela Agartala, Cane and Bamboo Technology Project outlets, NE craft fairs.',
  notable_exponents = 'Tripura Bamboo Mission artisans; district handicraft societies.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-TR' AND i.item_name = 'Tripuri Bamboo-Cane Art';

-- Uttar Pradesh — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Banaras gulabi meenakari: pink-dominated enamel on gold or kundan jewellery and objets—flowers, birds, and arabesques fired in chulha kilns by Hindu and Muslim meenakar.',
  about_state_tradition = 'Varanasi lanes specialize in blue, green, and signature gulabi (rose) enamel on chased gold; technique pairs with Banarasi brocade luxury economy.',
  history = 'Mughal court diffusion; export to Persian Gulf markets; modern hallmarking and tourist demand sustain micro-workshops.',
  cultural_significance = 'Bridal jewellery grammar of North India; intangible heritage of mixed-faith artisan guilds.',
  practice_and_pedagogy = 'Metal chasing, enamel powder laying, multiple firings, polishing; eye strain limits daily hours.',
  performance_context = 'Vishwanath Gali showrooms, India International Jewellery Show, museum vaults.',
  notable_exponents = 'National award meenakars in Banaras and Lucknow clusters.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-UP' AND i.item_name = 'Banaras Gulabi Meenakari Art';

-- Uttarakhand — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Aipan: Kumaon ritual floor and wall drawing with rice paste (biswar) on geru (red ochre) ground—swastika, lakshmi feet, chowki patterns for ceremonies.',
  about_state_tradition = 'Drawn by women on thresholds for vivah, janeu, shraddha, and seasonal feasts. Motifs include rhombic mandalas, diya arrays, and nature stylizations.',
  history = 'Oral manuals (lok parampara) govern auspicious timing; NGOs document for urban diaspora losing wall surfaces.',
  cultural_significance = 'Sacred geometry of Himalayan Hindu homes; feminist scholarship highlights women''s ritual authorship.',
  practice_and_pedagogy = 'Finger, brush, or comb tools; symmetry taught by copying mother; adaptation to paper for sale.',
  performance_context = 'Village homes, Kumaon University folk arts, tourism homestays.',
  notable_exponents = 'Kumaoni women artist collectives; Aipan revival NGOs in Almora.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-UK' AND i.item_name = 'Aipan Ritual Floor Art';

-- West Bengal — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Kalighat pat: nineteenth-century watercolour bazaar art near Kali temple—bold kalighat brush line, satirical babu–bibi cartoons, and mythic heroines on mill paper.',
  about_state_tradition = 'Rural patuas migrated to Calcutta; hybrid style influenced modern masters (Chittaprosad, Jamini Roy). Cheap pigments and swift production met pilgrim demand.',
  history = 'Rise with wood pulp paper; decline with lithography; museum canonization at Victoria Memorial and abroad.',
  cultural_significance = 'India''s first modern visual mass culture; colonial modernity critique in images.',
  practice_and_pedagogy = 'Single-tuft brush economy; limited palette; contemporary patuas revive narrative scroll (pater gaan) alongside Kalighat homage.',
  performance_context = 'Art galleries, CIMA and DAG exhibitions, patachitra melas in Medinipur.',
  notable_exponents = 'Historical anonymous masters; Kalam Patua; contemporary revivalists.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-WB' AND i.item_name = 'Kalighat Pat Visual School';

-- Andaman and Nicobar
UPDATE public.cultural_state_items i SET
  short_description = 'Nicobari shell and cane: necklaces, armlets, and utilitarian weaving integrating cowrie, nautilus slices, and pandanus—maritime material culture of Nicobar Islands.',
  about_state_tradition = 'Nicobarese and Shompen-linked craft economies respect seasonal shell gathering taboos; designs signal island and village identity.',
  history = '2004 tsunami disrupted communities; reconstruction NGOs revived craft for livelihood; access restrictions protect indigenous knowledge.',
  cultural_significance = 'Tourist-regulated heritage; symbol of resilient island cosmology.',
  practice_and_pedagogy = 'Community elders control motif teaching; workshops pair shell drilling with sustainable sourcing rules.',
  performance_context = 'Sagarika emporium Port Blair, restricted tourism fairs, museum ethnography.',
  notable_exponents = 'Nicobar craft cooperatives; ANET documentation projects.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-AN' AND i.item_name = 'Nicobari Cane-Shell Art';

-- Chandigarh
UPDATE public.cultural_state_items i SET
  short_description = 'Punjabi Sufi stage visuality: curated mehfil and festival presentation of qawwali, Sufiana kalam, and Punjabi folk–Sufi fusion with choreographed lighting, ensemble dress, and architectural backdrops.',
  about_state_tradition = 'Chandigarh''s Tagore Theatre, Punjab Kala Akademi, and university auditoria standardize “high culture” frames for devotional music once informal.',
  history = 'Partition brought artists from Lahore circuit; state institutions archive Ustad recordings and costume evolution.',
  cultural_significance = 'Cross-border lyrical memory (Bulleh Shah, Waris Shah) in secular public sphere.',
  practice_and_pedagogy = 'Stage design courses intersect with gharana vocal training; repertory companies maintain wardrobe inventories.',
  performance_context = 'Harivallabh Sangeet Sammelan vicinity, Rose Festival cultural nights, Punjabi University festivals.',
  notable_exponents = 'Punjab Arts Council repertory; Sufi festival curators.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-CH' AND i.item_name = 'Punjabi Sufi Stage Visual Tradition';

-- Dadra and Nagar Haveli and Daman and Diu
UPDATE public.cultural_state_items i SET
  short_description = 'Coastal mural art of Daman–Diu: Indo-Portuguese church frescos, fort lime plasters, and Hindu temple narrative walls—tropical pigment fading and maritime salt challenges.',
  about_state_tradition = 'Se Cathedral and chapel cycles show Iberian saints adapted to local pigment palette; Hindu shrines use brighter poster-colour revival layers.',
  history = 'Portuguese Estado Novo-era restoration contrasts with post-1961 Indian ASI conservation.',
  cultural_significance = 'Visible layer of UT''s plural coastal history.',
  practice_and_pedagogy = 'Conservation chemistry training at regional workshops; living mural painters for temple navagraha cycles.',
  performance_context = 'Heritage walks, church feasts, Diu Festival art trails.',
  notable_exponents = 'Diu Museum conservation cell; local stucco families.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-DN' AND i.item_name = 'Daman-Diu Coastal Mural Art';

-- Delhi
UPDATE public.cultural_state_items i SET
  short_description = 'Delhi Hindustani stage art: sabha culture visuality—tanpura placement, musician seating (humayun posture), spotlight grammar, and festival mandap design for Hindustani classical.',
  about_state_tradition = 'Institutions like IGNCA, Kamani Auditorium, and India Habitat Centre codify audience–artist sightlines; costume remains understated to privilege sound.',
  history = 'From jalsaghar to FM radio to HD streaming, Delhi shaped national classical music presentation standards.',
  cultural_significance = 'Capital soft power; archival photography of gharana giants.',
  practice_and_pedagogy = 'Event management diplomas now include Indian classical ergonomics; gurus teach microphone etiquette.',
  performance_context = 'Delhi Classical Music Festival, Spic Macay, ICCR dossiers.',
  notable_exponents = 'Sabha secretaries; festival lighting designers; NCERT arts modules.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-DL' AND i.item_name = 'Delhi Hindustani Stage Art';

-- Jammu and Kashmir — primary
UPDATE public.cultural_state_items i SET
  short_description = 'Kashmiri papier-mâché: sakhtsazi (papier pulp moulding) plus naqashi (painted lacquer finish)—floral arabesques, chinar leaves, and box, tray, and ornament forms.',
  about_state_tradition = 'Srinagar''s Shia and Sunni artisan quarters supply tourist and export markets; motifs echo Persianate and local botanical worlds.',
  history = 'Sultanate-era Central Asian introduction myth; Victorian mail-order popularity; conflict periods disrupted supply chains.',
  cultural_significance = 'UNESCO craft-city narratives; symbol of Kashmiri domestic artistry.',
  practice_and_pedagogy = 'Mould-making, layering pulp, sun drying, sandpaper, base colour, brush sizes from squirrel to goat, varnish.',
  performance_context = 'Dal gate shops, GI tagged showrooms, Craft Development Institute Srinagar.',
  notable_exponents = 'National award naqash families; CDI trainee entrepreneurs.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-JK' AND i.item_name = 'Kashmiri Papier-Mache Art';

-- Ladakh
UPDATE public.cultural_state_items i SET
  short_description = 'Ladakhi monastic art: thangka, appliqué (tib. chenrezig large hangings), and temple murals following Tibetan Buddhist canon in high-altitude light conditions.',
  about_state_tradition = 'Hemis, Thiksey, and Alchi (early Kashmiri-influenced murals) anchor routes; mineral pigments differ by local availability.',
  history = 'Western Tibet cultural sphere; Dogra and modern Indian army logistics changed patronage; tourism funds restoration.',
  cultural_significance = 'Pilgrimage economy core; climate-change documentation of wall paintings.',
  practice_and_pedagogy = 'Monastic shedras (colleges) teach draughtsmanship; mural teams work on bamboo scaffolding.',
  performance_context = 'Hemis Festival displays, monastery guestshops, Leh palace exhibitions.',
  notable_exponents = 'Thiksey and Likir atelier monks; lay thangka painters in Leh.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-LA' AND i.item_name = 'Ladakhi Monastic Art';

-- Lakshadweep
UPDATE public.cultural_state_items i SET
  short_description = 'Lakshadweep shell craft: cowrie assembly, coral-stone avoidance per regulation, and coconut coir integration—ornamental objects for island and tourist circulation.',
  about_state_tradition = 'Malayalam-speaking Muslim islanders combine fishing downtime with craft; designs echo Arab Ocean trade aesthetics.',
  history = 'Union Territory welfare corporations market through Kochi; plastic-ban policies boost natural material rhetoric.',
  cultural_significance = 'Eco-tourism identity; gendered home industry.',
  practice_and_pedagogy = 'Hand drilling, threading patterns, lacquer finishing workshops by LACCADIVES corporations.',
  performance_context = 'Agatti and Kavaratti emporia, ship-duty-free counters.',
  notable_exponents = 'Society for Promotion of Nature Conservation and Research linked livelihood groups.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-LD' AND i.item_name = 'Lakshadweep Shell Craft Art';

-- Puducherry
UPDATE public.cultural_state_items i SET
  short_description = 'Puducherry sacred art palimpsest: Tamil temple sculpture conservancy, French colonial church stained glass and statuary, and Ashram atelier graphics (Aurobindo circle).',
  about_state_tradition = 'White Town architecture frames Catholic visual culture; Tamil quarters maintain Dravidian temple festivals with silver ratha ornaments.',
  history = 'French East India Company town planning; de jure integration with Indian Union; INTACH Puducherry documents façades.',
  cultural_significance = 'Coastal Tamil cosmopolitanism; heritage tourism bilingual signage.',
  practice_and_pedagogy = 'Puducherry University fine arts; French Institute partnerships; sthapathi apprenticeships visiting from Tamil Nadu.',
  performance_context = 'Heritage Festival, Basilica feasts, Sri Aurobindo Handmade Paper and art units.',
  notable_exponents = 'Puducherry Museum conservation; Ashram art departments.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-PY' AND i.item_name = 'Puducherry Franco-Tamil Devotional Art';

-- ========== Second art profile per state (20260327_009 expansion) ==========

-- Andhra Pradesh — Lepakshi
UPDATE public.cultural_state_items i SET
  short_description = 'Lepakshi Vijayanagara murals: sixteenth-century Shaiva narrative frescoes on mandapa ceilings—linear grace, pomegranate reds, and episodes from Kiratarjuniya and Ramayana.',
  about_state_tradition = 'The Veerabhadra temple at Lepakshi preserves some of South India''s largest surviving Vijayanagara painting fields despite pigment loss; Archaeological Survey of India conservation stabilizes flakes.',
  history = 'Built under Vijayanagara late phase patronage; myth ties to sage Agastya and Jatayu; comparison to Hampi and Tiruppanmalai cycles places Lepakshi in court atelier diffusion.',
  cultural_significance = 'Pilgrimage art history destination; textile and jewellery motifs in paintings influence contemporary design archives.',
  practice_and_pedagogy = 'Modern conservation science trains restorers; fine-art students copy line vocabulary for study—not revived as living mural school.',
  performance_context = 'ASI-guided tourism, digital panoramic documentation, symposium volumes.',
  notable_exponents = 'ASI mural conservation teams; art historians documenting Lepakshi corpus.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-AP' AND i.item_name = 'Lepakshi Mural Tradition';

-- Assam — manuscript painting
UPDATE public.cultural_state_items i SET
  short_description = 'Assamese sanchipat and agar bark manuscripts: miniature painting on prepared bark with talismanic diagrams, Vaishnavite illuminations, and Ankiya play sketches.',
  about_state_tradition = 'Satra libraries hold pothis with vegetable pigments and iron gall ink; bamboo styli and hand-made brushes serve humid climate.',
  history = 'Ahom court and satra scribal culture; colonial ethnography collected samples now in British Library and Guwahati museums.',
  cultural_significance = 'Manuscript = living liturgy reference for Bhaona and naam; intangible link to Sattriya ecosystem.',
  practice_and_pedagogy = 'Few living practitioners; Srimanta Sankaradeva Kalakshetra teaches documentation and facsimile arts.',
  performance_context = 'Rare exhibitions; digitization projects; climate-controlled satra archives.',
  notable_exponents = 'Manuscript conservators at Kala Bhavan; satra pothikar lineages.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-AS' AND i.item_name = 'Assamese Manuscript Painting';

-- Bihar — Manjusha
UPDATE public.cultural_state_items i SET
  short_description = 'Manjusha: Anga region scroll and box painting with characteristic snake-looped frames—folklore of Bishahari (snake goddess) in yellow, green, and pink flat colour.',
  about_state_tradition = 'Bhagalpur district festival art tied to Nag Panchami; artists paint on recycled boxes and jute stretched as scrolls; line recalls serpent coils enclosing narrative panels.',
  history = 'Nearly extinct mid-twentieth century; national awards and state fairs revived practice; GI application discourse.',
  cultural_significance = 'Distinct from Mithila Madhubani—more axial symmetry and snake border grammar.',
  practice_and_pedagogy = 'Workshops by Vikas Bharti and state culture department; colour symbolism taught as ritual code.',
  performance_context = 'Delhi Republic Day tableau, Bhagalpur silk fairs, folk art archives.',
  notable_exponents = 'Chakravarty Devi (late); revivalist artists in Kharagpur and Bhagalpur.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-BR' AND i.item_name = 'Manjusha Art';

-- Chhattisgarh — Bastar tribal wall art (expansion)
UPDATE public.cultural_state_items i SET
  short_description = 'Bastar adivasi wall art beyond dhokra: red ochre and charcoal figurative and geometric murals on wattle–daub, often paired with gotul youth dormitory culture.',
  about_state_tradition = 'Gond, Muria, and Maria villages paint before harvest and marriage; motifs include mahua, hornbill, and ancestor sticks.',
  history = 'Anthropologists Verrier Elwin documented mid-century walls; today NGOs pair mural tourism with consent protocols.',
  cultural_significance = 'Living surface unlike metal cast; gendered roles in who may paint which wall.',
  practice_and_pedagogy = 'Village elders set taboos on colours; young artists learn through festival participation.',
  performance_context = 'Bastar Dussehra tourist circuits, adivasi art residencies.',
  notable_exponents = 'District collectives documented by Tribal Research Institute Raipur.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-CT' AND i.item_name = 'Bastar Tribal Wall Art';

-- Gujarat — Mata ni Pachedi
UPDATE public.cultural_state_items i SET
  short_description = 'Mata ni Pachedi: Kalamkari-related shrine cloth of Gujarat''s Vaghari community—block-printed and painted mother goddesses as portable temple when entry to caste temples was barred.',
  about_state_tradition = 'Ahmedabad and Vasna workshops use mordant and natural dyes on cotton; central goddess (Amba, Meldi, etc.) surrounded by narrative vignettes.',
  history = 'Social exclusion ironically produced powerful visual tradition; contemporary artists like Sanjay Chitara exhibit globally.',
  cultural_significance = 'Subaltern devotional architecture on cloth; post-caste inclusion reframes patronage.',
  practice_and_pedagogy = 'Bamboo kalam, block registration, multiple dye dips; narrative sequence taught as ritual requirement.',
  performance_context = 'Craft museums, Kochi Biennale collateral, domestic shrines during Navratri.',
  notable_exponents = 'National award Vaghari painter families in Ahmedabad.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-GJ' AND i.item_name = 'Mata ni Pachedi';

-- Himachal Pradesh — Chamba Rumal
UPDATE public.cultural_state_items i SET
  short_description = 'Chamba rumal: double-sided satin-stitch embroidery on muslin—miniature painting compositions in needle, often Kangra faces under mango trees.',
  about_state_tradition = 'Royal Chamba ateliers paired painters with embroiderers; rumals exchanged as wedding gifts; revived through CCI and designer collaborations.',
  history = 'Queen Charumati patronage legend; decline with machine lace; GI registration (2007) for Chamba rumal.',
  cultural_significance = 'Pahari painting in textile; gendered embroidery guild memory.',
  practice_and_pedagogy = 'Draw design in charcoal; split stitch fills both sides identically; years per masterpiece.',
  performance_context = 'Kangra Museum, Delhi crafts fairs, luxury textile auctions.',
  notable_exponents = 'National awardee embroiderers in Chamba town.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-HP' AND i.item_name = 'Chamba Rumal Art';

-- Jharkhand — Jadopatia
UPDATE public.cultural_state_items i SET
  short_description = 'Jadopatia: Santhal narrative scroll painting on leaf or paper with natural pigments—pat scroll unrolled by jadu-patiyas (singers) for birth, marriage, and death rites.',
  about_state_tradition = 'Dumka and bordering Bengal sustain scroll pairs (male–female figures) and sequential panels of myth and daily life.',
  history = 'Linked to wider pat scroll belt; documented by anthropologists; market competition from print pamphlets.',
  cultural_significance = 'Santhal worldview diagram—cosmic tree, chando babu cycles, moral tales.',
  practice_and_pedagogy = 'Hereditary singer-painter families; tonal singing matched to unrolling speed.',
  performance_context = 'Village night gatherings, Adivasi documentation centres.',
  notable_exponents = 'Santhal jadu-patiya lineages in Dumka district.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-JH' AND i.item_name = 'Jadopatia Scroll Art';

-- Karnataka — Mysore Ganjifa
UPDATE public.cultural_state_items i SET
  short_description = 'Mysore Ganjifa: circular lacquered playing cards hand-painted with dashavatara, navagraha, or raga sets—wood discs with tortoise-shell polish sheen.',
  about_state_tradition = 'Wodeyar court sponsored 96- or 120-card decks; Chitrakala Parishath keeps revival workshops; related to Odisha and Sawantwadi ganjifa variants.',
  history = 'Mughal ganjifa name from Persian; Mysore style uses mineral colours on wood thin cuts.',
  cultural_significance = 'Game + portable painting gallery; intangible toy as high art.',
  practice_and_pedagogy = 'Wood rounding, gesso, painting under magnifier, lac burnish.',
  performance_context = 'Craft melas, collector circles, museum vitrines.',
  notable_exponents = 'Ganjifa revivalists affiliated with Mysuru heritage foundations.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-KA' AND i.item_name = 'Karnataka Mysore Ganjifa Art';

-- Kerala — mural tradition (expansion)
UPDATE public.cultural_state_items i SET
  short_description = 'Kerala temple murals: fresco-secco on laterite and adobe walls—Shiva, Vishnu, and Shakti cycles in low horizon compositions, mineral greens and terracotta reds.',
  about_state_tradition = 'Padmanabhapuram, Mattancherry, and Thrissur temples hold masterpieces; stylistic phases from late medieval to Nayaka.',
  history = 'Chithari puja consecrates walls; ASI and INTACH stabilize humidity damage.',
  cultural_significance = 'Dance and theatre borrow poses directly from mural figures.',
  practice_and_pedagogy = 'Few muralists (e.g. Guruvayur tradition) take decades-long apprenticeships; chemistry of lime plaster taught.',
  performance_context = 'Temple darshan, restricted photography zones, scholarly volumes.',
  notable_exponents = 'Kerala mural artists national awardees; Sastra-based sthapathi consultants.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-KL' AND i.item_name = 'Kerala Mural Tradition';

-- Madhya Pradesh — Bhil painting
UPDATE public.cultural_state_items i SET
  short_description = 'Bhil art: dotted and linear narratives on cloth and paper—Pithora echoes, nature spirits, and festival scenes from Jhabua–Dhar belt.',
  about_state_tradition = 'Distinct from Gond though neighbouring; uses high chroma acrylic in modern market; traditional wall work on houses during Holi.',
  history = 'Adivasi Lok Kala Akademi Bhopal platforms artists; global exhibitions pair Bhil with Australian Aboriginal curatorial frames.',
  cultural_significance = 'Visualizes Bhil cosmology and seasonal rituals.',
  practice_and_pedagogy = 'Dotting rhythm taught as meditation; narrative lists from oral epics.',
  performance_context = 'Tribal Museum Bhopal, Indira Gandhi Rashtriya Manav Sangrahalaya.',
  notable_exponents = 'Bhuri Bai; Lado Bai; regional national awardees.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-MP' AND i.item_name = 'Bhil Painting';

-- Maharashtra — Pinguli Chitrakathi
UPDATE public.cultural_state_items i SET
  short_description = 'Pinguli Chitrakathi: leather puppet painting and flat card figures for Marathi Ramayana–Mahabharata singing—Konkan border village near Kudal.',
  about_state_tradition = 'Chitrakathi artists paint vegetable colours on deer-hide (now regulated—substitutes used); performance uses same images as cue cards.',
  history = 'Related to Tholu Bommalata and shadow puppet genealogies; decline pushed UNESCO documentation.',
  cultural_significance = 'Marathi-speaking puppet idiom bridging Karnataka and Maharashtra coasts.',
  practice_and_pedagogy = 'Family troupes train voice and brush; perforation for jointed puppets.',
  performance_context = 'Sawantwadi palace programmes, folk festivals, museum acquisitions.',
  notable_exponents = 'Pinguli Parshuram Gangavane lineage.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-MH' AND i.item_name = 'Pinguli Chitrakathi';

-- Odisha — Tala Pattachitra
UPDATE public.cultural_state_items i SET
  short_description = 'Tala pat: palm-leaf etching and pigment rubbing—horizontal strips joined by thread, carrying mantras, horoscopes, and miniature Krishnalila.',
  about_state_tradition = 'Raghurajpur and other villages engrave with iron stylus; black lamp soot fills grooves; wooden covers protect odia manuscripts.',
  history = 'Temple donation records and jyotisha manuals; British Library holds historic strips.',
  cultural_significance = 'Portable library before print; tourist souvenir evolution.',
  practice_and_pedagogy = 'Steady hand curvature on brittle leaf; family specialization in text vs image strips.',
  performance_context = 'Heritage village demos, IGNCA workshops.',
  notable_exponents = 'Pattachitra–tala pat dual-skilled chitrakar families.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-OR' AND i.item_name = 'Tala Pattachitra';

-- Punjab — Phulkari (expansion entry)
UPDATE public.cultural_state_items i SET
  short_description = 'Punjab Phulkari: bagh and darshan dwar variants from East Punjab—geometric shat-kona and diamond-key lattices, cowrie shells stitched as filler, and narrative panels in rare sainchi phulkari.',
  about_state_tradition = 'This state-level entry emphasizes undivided Punjab vocabulary: sainchi (figurative) and suber (triangular wedding) types; silk floss on khaddar.',
  history = 'Partition museums preserve refugee phulkaris; contemporary artists like Harjeet Kaur Singh reinterpret gender politics.',
  cultural_significance = 'Sikh and Hindu Punjabi shared bridal heritage; hip-hop and fashion sampling.',
  practice_and_pedagogy = 'Village tandas and urban ateliers; CAD patterns now assist symmetry.',
  performance_context = 'Punjab Agricultural University fairs, diaspora Canada museums.',
  notable_exponents = 'Indigenous women collectives; design labels reviving bagh density.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-PB' AND i.item_name = 'Punjab Phulkari Art';

-- Rajasthan — Kishangarh miniature
UPDATE public.cultural_state_items i SET
  short_description = 'Kishangarh school: Radha–Krishna idealized as Bani Thani—elongated eye, arched brow, and lotus face on midnight blue grounds.',
  about_state_tradition = 'Eighteenth-century Nihal Chand atelier under Savant Singh (Nagaridas); refined devotional lyricism.',
  history = 'Art market labels “Bani Thani” for tourist oils differ from museum originals; Rajasthan Lalit Kala documents copies.',
  cultural_significance = 'Peak of Rajput miniature emotionalism; influences calendar art and jewellery campaigns.',
  practice_and_pedagogy = 'Contemporary miniaturists in Kishangarh train in wasli and squirrel brush like Kangra revival.',
  performance_context = 'National Museum, Mehrangarh collaborations, export miniatures.',
  notable_exponents = 'Historical Nihal Chand; modern award painters in Kishangarh town.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-RJ' AND i.item_name = 'Kishangarh Miniature School';

-- Tamil Nadu — Kolam
UPDATE public.cultural_state_items i SET
  short_description = 'Kolam: daily threshold rice-flour or chalk line drawing—matrix knots, lotus loops, and seasonal patterns inviting prosperity and feeding insects symbolically.',
  about_state_tradition = 'Tamil homes, temples, and mathas renew kolam before sunrise; competitions during Margazhi elevate complexity.',
  history = 'Sangam poetry echoes floor art; mathematical papers study kolam as L-systems; NGOs promote eco rice paste over synthetic powder.',
  cultural_significance = 'Women''s ephemeral public art; diaspora apartment kolam apps.',
  practice_and_pedagogy = 'Grid counting taught young; pulli (dot) templates passed orally.',
  performance_context = 'Margazhi contests, Chennai sabha entrances, Pongal kolam streets.',
  notable_exponents = 'Margazhi kolam competition winners; math professors studying kolam combinatorics.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-TN' AND i.item_name = 'Kolam Ritual Art';

-- Telangana — Nirmal painting
UPDATE public.cultural_state_items i SET
  short_description = 'Nirmal art: teak-wood toys and panels with Mughal–Persian garden scenes and gold ashrafis—lacquer finish from Nirmal town once called "Telangana''s Kashmir."',
  about_state_tradition = 'Painters use natural dyes and gold foil on soft wood; allied to miniature furniture and dhokra display stands.',
  history = 'Nizam patronage myth; decline and 1980s revival through APCO and design interventions.',
  cultural_significance = 'State handicraft identity alongside Cheriyal scrolls.',
  practice_and_pedagogy = 'Wood seasoning, fine brush on black-lac base, varnish; toy-making apprenticeship.',
  performance_context = 'Hyderabad craft fairs, state emporia, export orders.',
  notable_exponents = 'Nirmal Kalakar Sangham artists.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-TS' AND i.item_name = 'Nirmal Painting';

-- Uttar Pradesh — Mathura school
UPDATE public.cultural_state_items i SET
  short_description = 'Mathura school (Kushan-era red sandstone sculpture): earliest monumental Indian Buddha and yakshi images with Hellenistic drapery traces—museum corpus defining classical figuration.',
  about_state_tradition = 'Archaeological sites around Mathura yield stylistic phases from Maurya polish to Gupta refinement; contemporary Mathura relies on conservation not revival carving at same scale.',
  history = 'Cunningham excavations; Lahore and Kolkata museum splits; ongoing illegal trafficking concerns.',
  cultural_significance = 'Art history anchor for Buddhist and Jain iconography courses worldwide.',
  practice_and_pedagogy = 'ASI site museums train guides; stone carvers today work new temple export from unrelated workshop lineages.',
  performance_context = 'Mathura Museum, site museums, digital 3D scans.',
  notable_exponents = 'ASI curators; academic historians of Kushan art.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-UP' AND i.item_name = 'Mathura School Visual Tradition';

-- Uttarakhand — Garhwal miniature
UPDATE public.cultural_state_items i SET
  short_description = 'Garhwal miniature: cousin to Kangra with local deity emphasis—Golu Devta narratives, mountain foliage, and Tehri court ateliers.',
  about_state_tradition = 'Mussorie and Srinagar (Pauri) hosted painters; palette cools toward alpine blues.',
  history = 'Tehri royal patronage; dispersal after integration with UP then Uttarakhand state.',
  cultural_significance = 'Himalayan Hindu visual identity distinct from plains Awadh.',
  practice_and_pedagogy = 'Contemporary artists at Almora Kala EVAM teach Pahari revival alongside Aipan.',
  performance_context = 'State Lalit Kala exhibitions; hill station galleries.',
  notable_exponents = 'Regional miniature painters documented by Uttarakhand arts academy.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-UK' AND i.item_name = 'Garhwal Miniature Tradition';

-- West Bengal — Bengal Patachitra
UPDATE public.cultural_state_items i SET
  short_description = 'Bengal patachitra: Medinipur and Birbhum scrolls with patua singers—Mangal kavya, Ramayana, and social satire on layered cloth or paper.',
  about_state_tradition = 'Patuas are Muslim artists singing Hindu epics—a unique syncretic performance; natural colours on starch-coated cloth.',
  history = 'UNESCO ICH listing for Durga Puja mentions patua participation; urban NGOs market pat scrolls as secular literacy tools.',
  cultural_significance = 'Oral literature + painting; gender-fluid patua lineages in some villages.',
  practice_and_pedagogy = 'Song–unroll timing taught before brush independence; contemporary health awareness scrolls.',
  performance_context = 'Poush Mela Santiniketan, village fairs, international folklore festivals.',
  notable_exponents = 'Swarna Chitrakar; Dukhushyam family; Kalighat crossover artists.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-WB' AND i.item_name = 'Bengal Patachitra';

-- Jammu and Kashmir — Khatamband
UPDATE public.cultural_state_items i SET
  short_description = 'Khatamband: geometric wooden ceiling (puzzle joinery without nails)—walnut and deodar polygons, stars, and arabesques assembled by master carpenters.',
  about_state_tradition = 'Srinagar old city homes, shrines, and houseboats feature floating lattice ceilings; each piece numbered for disassembly.',
  history = 'Persian craft name; patronage under Sultanate and Dogra eras; post-2019 market recovery narratives.',
  cultural_significance = 'Interior architecture as visual art; cooling microclimate under wood.',
  practice_and_pedagogy = 'Multi-year joinery apprenticeship; geometry from full-scale cardboard templates.',
  performance_context = 'Heritage home restorations, luxury hotel Srinagar, craft documentation films.',
  notable_exponents = 'Wani and Sheikh carpenter guilds; Craft Development Institute trainees.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_art' AND h.state_code = 'IN-JK' AND i.item_name = 'Kashmiri Khatamband Design Art';
