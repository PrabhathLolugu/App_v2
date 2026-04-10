-- Expand food_state_items with richer copy tied to Hindu / Indian cultural practice
-- (temple naivedyam, vrata, harvest utsava, grhya rites, pilgrimage foods).
-- Does NOT touch cover_image_url or gallery_urls.

UPDATE public.food_state_items f SET
  short_description = 'Pulihora (chitrannam): tamarind rice sanctified as prasadam across Andhra–Telangana temples—tang of tamarind as amrita of the feast, sesame and peanuts as auspicious dravya.',
  about_food = 'In Sri Vaishnava and Smarta kitchens pulihora is a standard naivedyam because it keeps well on chariot processions and satiates crowds after kalyanam. The yellow of turmeric invokes solar purity; offering cooled rice mixed with puliyogare podi or fresh paste completes the alankara for the deity.',
  history = 'Medieval temple inscription kitchens and agraharam women''s networks standardized the tempering sequence; railway pilgrims spread the taste pan-India as temple rice.',
  ingredients = 'Sona masuri or ponni rice, thick tamarind extract, sesame oil, mustard, chana dal, urad dal, curry leaf, dried red chilli, turmeric, roasted peanuts, sesame seeds, hing; optional jaggery balance.',
  preparation_style = 'Cook rice firm; cool completely. Fry dals and spices in sesame oil, simmer tamarind to thick pulikachal, fold into rice without mashing. Some temples add roasted mustard powder on festival days.',
  serving_context = 'Navaratri kolu visitors, Satyanarayana vrata conclusion, Hanuman kalyanam, Tirupati laddu counters sibling prasadam culture, domestic shraaddha vegetarian meals.',
  nutrition_notes = 'Complex carbs with legume bits and oil-soluble spices; peanut adds protein; tamarind aids iron absorption—fits lacto-vegetarian temple diet.',
  best_season = 'Year-round; peak demand during Brahmotsavams and village jatara seasons.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-AP' AND f.food_name = 'Pulihora';

UPDATE public.food_state_items f SET
  short_description = 'Bellam pongali: Sankranti naivedyam of rice, moong, ghee, and jaggery—sweetness as gratitude to Surya and the harvest, shared as pongal abundance.',
  about_food = 'Andhra households cook it in new pots on Makara Sankranti, sometimes with turmeric knot and sugarcane beside the stove. It embodies the same symbolic grammar as Tamil pongal: overflow (pongu) as blessing.',
  history = 'Chola-era harvest hymns echo rice–dal boiled offerings; today it bridges Telugu agrarian calendars with pan-South Indian krittika/sankranti convergence.',
  ingredients = 'Raw rice, split moong dal, grated jaggery, ghee, cardamom, cashews, raisins, coconut slivers, pinch of edible camphor optional.',
  preparation_style = 'Roast dal lightly, pressure-cook with rice soft, mash; melt jaggery with water, strain, merge and simmer; finish with ghee-fried nuts and coconut.',
  serving_context = 'Sankranti puja, Dhanya Lakshmi homa follow-up meals, temple kalyana utsava annadanam sweet course.',
  nutrition_notes = 'High-energy festival food; jaggery minerals; moong protein; use portion awareness for diabetics.',
  best_season = 'Winter harvest / Makara Sankranti; also Bhogi and Kanuma.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-AP' AND f.food_name = 'Bellam Pongali';

UPDATE public.food_state_items f SET
  short_description = 'Apong rice cake: fermented rice flour steamed in leaves—offered in Adi, Solung, Mopin, and harvest thanksgiving as grain returned to community and spirits.',
  about_food = 'Across Tani, Adi, and Mishmi contexts, rice cakes anchor communal feasts where Christianity and indigenous cosmology meet; Hindu neighbours often share the same plates at inter-village melas, marking Northeast pluralism.',
  history = 'Shifting cultivation cycles set the ritual calendar; bamboo-leaf wrap preserves aroma and signals forest–river reciprocity.',
  ingredients = 'Rice flour, jaggery or mild sugar, coconut, sesame, banana or phrynium leaves for steaming.',
  preparation_style = 'Ferment batter lightly, spread on leaf, wrap, steam until springy; variants add black sesame for colour contrast.',
  serving_context = 'Harvest first-fruits, housewarming community meals, church-adjacent cultural days, Republic Day state showcases.',
  nutrition_notes = 'Gluten-free carbohydrate; fermentation may ease digestion; moderate sugar.',
  best_season = 'Post-harvest autumn and winter gatherings.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-AR' AND f.food_name = 'Apong Rice Cake';

UPDATE public.food_state_items f SET
  short_description = 'Til pitha: cylinder of roasted rice flour and black sesame–jaggery—Magh Bihu (Bhogali Bihu) breakfast, embodying warmth, light, and agrarian renewal after winter.',
  about_food = 'Assamese Hindu and broader Assamese society greet the solstice with hearth fires (meji) and til pitha exchange among kin; til (sesame) is pan-Indian sankranti symbolism for longevity and merit.',
  history = 'Ahom-era rural chronicles note rice–til sweets; today it is a UNESCO ICH-framed Bihu cluster emblem.',
  ingredients = 'Bora saul or sticky rice flour, black sesame, jaggery, sometimes coconut.',
  preparation_style = 'Dry-roast flour, roll thin warm sheet on iron tawa, fill with sesame–jaggery, coil or fold while pliable.',
  serving_context = 'Magh Bihu morning, bride''s first Bihu in sasural, offered to elders before community feast.',
  nutrition_notes = 'Calcium and iron from sesame; energy dense; jaggery trace minerals.',
  best_season = 'Magh (January) peak; dry winter storage possible.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-AS' AND f.food_name = 'Til Pitha';

UPDATE public.food_state_items f SET
  short_description = 'Khar: banana-ash alkali starter with raw papaya or pulses—foundational Assamese sattvic course, cleansing palate before richer bhaji in traditional xaaj.',
  about_food = 'Khar aligns with older Indian use of natural alkalis in cooking (kshara) and with no-onion–no-garlic meal days. It is offered on death anniversaries and simple shraddha plates as mild, pure food.',
  history = 'Indigenous knowledge predates recorded cookbooks; colonial ethnographers filed it under tribal-Hindu synthesis.',
  ingredients = 'Dried banana peel ash filtrate (khar liquid), raw papaya or split masoor, mustard oil, salt, green chilli, sometimes lentil dumplings (bora).',
  preparation_style = 'Simmer vegetables with measured khar water until tender; balance sour with slight jaggery if needed; finish with mustard tempering.',
  serving_context = 'First course in assamese hindu feast line, monday vegetarian days, post-temple meal simplicity.',
  nutrition_notes = 'Low oil, high fiber from papaya; alkali softens pulses—easy on digestion.',
  best_season = 'Year-round; raw papaya best in monsoon abundance.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-AS' AND f.food_name = 'Khar';

UPDATE public.food_state_items f SET
  short_description = 'Litti chokha: sattu-stuffed whole-wheat ball roasted in cow-dung fire or oven, with smoked brinjal–tomato mash—pilgrim fuel of Bihar and the language of Chhath ghats.',
  about_food = 'Tied to Bhojpuri-Magahi identity, litti sustained sadhus and farmers; chokha''s smoke recalls havan ash and field-edge cooking. It appears in wedding baraats and Kumbh camps as vegetarian strength food.',
  history = 'Maurya-to-modern continuity of sattu culture; urban ovens now replace dung but ghee-dipped ritual remains.',
  ingredients = 'Atta, roasted gram sattu, ajwain, mustard oil, pickle spice; chokha: baingan, tomato, potato, mustard oil, green chilli, garlic optional (strict sattvic omit).',
  preparation_style = 'Stuff dough, roast till crust cracks, dunk in ghee; char vegetables, peel, mash with mustard oil tempering.',
  serving_context = 'Chhath evening after nirjala fast (family variation), Sama Chakeva, rural fairs, Bodh Gaya pilgrim stalls.',
  nutrition_notes = 'High fiber and plant protein from sattu; smoked veg add antioxidants; heavy—pair with buttermilk.',
  best_season = 'Year-round; winter bonfire roasting iconic.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-BR' AND f.food_name = 'Litti Chokha';

UPDATE public.food_state_items f SET
  short_description = 'Thekua: deep-fried jaggery–wheat nuggets—Chhath Mahaparv prasad offered to Surya and Chhathi Maiya at river ghats.',
  about_food = 'Women''s vrata kitchens prepare thekua in large batches for sandhya arghya and usha arghya; shape and edge crimping vary by family as latent signature of devotion.',
  history = 'Mahabharata folk links to Draupadi''s sun vow retold in Puranic vrata kathas; Bihar-Nepal Terai continuity.',
  ingredients = 'Whole wheat flour, grated jaggery, ghee or oil, fennel, coconut flakes, cardamom.',
  preparation_style = 'Rub ghee into flour, bind with jaggery syrup, rest, roll thick, cut patterns, slow-fry for shelf-stable prasad.',
  serving_context = 'Chhath Puja core prasad, also Kartik vrata baskets, distributed to neighbours as punya sharing.',
  nutrition_notes = 'Energy-dense travel prasad; jaggery iron; fried—occasional ritual portion.',
  best_season = 'Kartik (October–November) primary.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-BR' AND f.food_name = 'Thekua';

UPDATE public.food_state_items f SET
  short_description = 'Faraa: steamed rice-lentil dumpling—Chhattisgarh vrata and festival soft food echoing pan-Indian idli-modak steam purity.',
  about_food = 'Served in Satnami and Gond–Hindu households on ekadashi-style fasts where oil is limited; community steamer stacks mirror temple potu kitchens.',
  history = 'Rice-belt central India adapted steam tech without coastal fermentation emphasis; fairs sell faraa with green chutney.',
  ingredients = 'Rice flour, chana or urad paste, cumin, coriander, salt, green chilli; tempering of mustard optional after steam.',
  preparation_style = 'Knead stiff dough, shape cylinders or crescents, steam 12–15 minutes, temper with jeera–rai in little oil.',
  serving_context = 'Navaratri light dinners, pitru paksha vegetarian days, Haat festival breakfast.',
  nutrition_notes = 'Steamed = lower fat; dal adds protein; easy on stomach for elders.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-CT' AND f.food_name = 'Faraa';

UPDATE public.food_state_items f SET
  short_description = 'Khatkhate: Saraswat Brahmin seven-vegetable coconut curry—Ganesh Chaturthi and shuddha divasa menus in Konkani Goa, balancing tulsi and temple timings.',
  about_food = 'Each vegetable is said to honor a different deity or season; coconut ties it to coastal Shaiva–Vaishnava syncretism. No onion–garlic keeps it aligned with deva-patra offerings.',
  history = 'Portuguese-era temple protection narratives intertwine with continued matha cooking; diaspora Goans carry khatkhate as identity anchor.',
  ingredients = 'Pumpkin, beans, drumstick, yam, sweet potato, ridge gourd, taro or chocho, fresh coconut, arid red chilli, tamarind, jaggery, hing, coconut oil.',
  preparation_style = 'Cook vegetables separately to texture, combine in coconut masala with tamarind–jaggery balance; finish with coconut oil tempering.',
  serving_context = 'Ganesh visarjan family lunch, Varada Lakshmi vrata, temple annadanam in Panaji area.',
  nutrition_notes = 'High fiber multivitamin mix; coconut adds sat fat—portion for cardiac diets.',
  best_season = 'Monsoon vegetable peak; festivals year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-GA' AND f.food_name = 'Khatkhate';

UPDATE public.food_state_items f SET
  short_description = 'Undhiyu: winter mixed-vegetable undhu (upside-down) pot—Uttarayan and Vasi Uttarayan feast, celebrating Makar Sankranti kite skies and Gujarati gruh laxmi''s seasonal larder.',
  about_food = 'Surti papdi, purple yam, and methi muthia encode Surat–Ahmedabad micro-regions; joint family undhiyu on terrace day ties to sun worship and charity kite-falls.',
  history = 'Patidar and farmer caste networks popularized community undhiyu; Jain vegetarian elite refined no-root variants.',
  ingredients = 'Surti papdi, baby brinjal, potatoes, sweet potato, yam, fresh tuvar lilva, methi muthia, coconut, sesame, green garlic (optional), spices, oil.',
  preparation_style = 'Layer vegetables with masala in handi or pressure cook; muthia steamed then simmered in; slow cook melds flavors.',
  serving_context = 'Makar Sankranti lunch, wedding feast vegetarian centerpiece with puri, Paryushan-adjacent homes adjust alliums.',
  nutrition_notes = 'Micronutrient diversity; oil-heavy—balance with kadhi.',
  best_season = 'Winter (Dec–Feb) for fresh papdi and lilva.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-GJ' AND f.food_name = 'Undhiyu';

UPDATE public.food_state_items f SET
  short_description = 'Khichdi–kadhi: moong–rice khichdi with gram-flour buttermilk kadhi—Gujarati vrata break-fast and Dhanteras simplicity meal, praised in Ayurvedic light-diet shastra.',
  about_food = 'Ekadashi parana and Dev Utthana Ekadashi often feature this pair; kadhi''s yogurt carries probiotic logic in a lacto culture that reveres dahi as auspicious.',
  history = 'Mercantile households needed quick sattvic meals between business hours; Swaminarayan mandirs institutionalize the combo.',
  ingredients = 'Rice, moong dal, turmeric, ghee; kadhi: yogurt, besan, ginger, green chilli, methi seeds, curry leaves, hing.',
  preparation_style = 'Pressure khichdi soft; whisk kadhi lump-free, simmer to silk, vaghar with methi–jeera.',
  serving_context = 'Temple mahaprasad lines, home Tuesday Hanuman fast end, post-yatra recovery meals.',
  nutrition_notes = 'Complete protein with dal–rice; kadhi adds calcium; moderate salt for BP.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-GJ' AND f.food_name = 'Khichdi Kadhi';

UPDATE public.food_state_items f SET
  short_description = 'Bajra khichdi: pearl millet and moong one-pot—Lohri–Sankranti hearth food of Haryana–Punjab belt, honoring rabi grain and Agni.',
  about_food = 'Sung in winter folk songs; offered in simple form to cow and elders on Lohri; aligns with Hindu reverence for anna from field to fire.',
  history = 'Harappan millet continuity; Green Revolution shifted wheat dominance but bajra retains ritual winter presence.',
  ingredients = 'Bajra grits or cracked pearl millet, moong chilka, ghee, cumin, hing, ginger, green chilli, salt.',
  preparation_style = 'Soak bajra if whole; pressure with dal; temper ghee spices; serve hot with lassi or raab.',
  serving_context = 'Lohri night supper, Maghi communal langar analogues, Kurukshetra pilgrimage dhabas.',
  nutrition_notes = 'Low GI energy, iron and magnesium; high fiber—hydrate well.',
  best_season = 'Winter (November–February).',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-HR' AND f.food_name = 'Bajra Khichdi';

UPDATE public.food_state_items f SET
  short_description = 'Madra: yogurt-braised chickpeas—Himachali Dham thali''s royal vegetarian course, originally temple-palace feasts on leaf plates.',
  about_food = 'Dham is served by botis (Brahmin cooks) at weddings and devta processions; madra''s sweet-sour yogurt base echoes Kashmiri yakhni contact zone while staying distinctly Pahadi.',
  history = 'Raja-era patronage; today UNESCO ICH interest in Kullu Dussehra includes dham culture.',
  ingredients = 'Kabuli chana soaked, thick curd, ghee, bay leaf, cardamom, clove, cinnamon, cumin, turmeric, coriander powder, dry mango powder or amchoor.',
  preparation_style = 'Simmer chickpeas tender, whisk curd with besan stabilizer optional, slow-cook gravy without splitting, finish with ghee temper.',
  serving_context = 'Wedding dham, village devta yatra meals, Dussehra community spreads.',
  nutrition_notes = 'Legume protein plus dairy calcium; rich—pair with plain rice.',
  best_season = 'Cool seasons; wedding calendar peak.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-HP' AND f.food_name = 'Madra';

UPDATE public.food_state_items f SET
  short_description = 'Dhuska: fermented rice-urad-chana fritter—Jharkhand mela snack and Karma festival sharing bread, akin to spiritual purity through fire like South Indian vadai.',
  about_food = 'Santal and Sadan Hindu melas fry dhuska in giant kadhais; offered to Karma deity and distributed as prasad-like community luck.',
  history = 'Chota Nagpur mining towns spread the snack; folk songs reference dhuska with ghugni.',
  ingredients = 'Soaked rice, chana dal, urad dal, cumin, green chilli, salt; oil to deep-fry.',
  preparation_style = 'Grind batter coarse, ferment lightly, pour ladlefuls in medium-hot oil for thick fluffy discs.',
  serving_context = 'Karma Naach nights, village fairs, Saraswati puja breakfast in Ranchi schools.',
  nutrition_notes = 'Fermentation aids B vitamins; fried—share portions; dal protein.',
  best_season = 'Year-round; festival spikes in Bhadra–Ashvina.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-JH' AND f.food_name = 'Dhuska';

UPDATE public.food_state_items f SET
  short_description = 'Bisi bele bath: one-pot rice, toor dal, vegetables, tamarind, and Mysore spice powder—Monday temple annadanam staple and Dasara palace heritage.',
  about_food = 'Name means hot lentil rice; linked to Mylari temple and Chamundi hill sevas. It encodes Karnataka''s middle path between puliyogare tang and pongal mildness.',
  history = 'Wodeyar-era palace kitchens and Udupi hotels standardized masala blends; packaged powders now carry the dharma of consistency.',
  ingredients = 'Rice, toor dal, mixed vegetables, tamarind pulp, jaggery, ghee, bisi bele masala (red chilli, dal, coriander, cinnamon, clove, fenugreek, coconut, sesame).',
  preparation_style = 'Cook dal–rice together or separate then merge; simmer vegetables in tamarind; add masala and ghee temper with cashews.',
  serving_context = 'Temple kalyana utsava, Monday Shiva vow meals, wedding afternoon tiffin.',
  nutrition_notes = 'Balanced meal; nuts optional; control ghee for calories.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-KA' AND f.food_name = 'Bisi Bele Bath';

UPDATE public.food_state_items f SET
  short_description = 'Kosambari: soaked moong–cucumber salad with coconut and lemon—Navaratri kanya puja plate and Upanayana auspicious cooling bite.',
  about_food = 'Offered as naivedyam before hot pongal in many Karnataka homes; raw sprouted dal signifies life force (prana) offered to Devi.',
  history = 'Agama-based temple prasadam manuals list similar soaked-dal preparations; Haridasa kirtans mention kosambari as simple bhakta food.',
  ingredients = 'Split moong soaked, cucumber, fresh coconut, lemon, salt, green chilli, coriander; temper urad–mustard–hing in coconut oil.',
  preparation_style = 'Drain dal well, toss with veg, temper hot oil poured last for aroma.',
  serving_context = 'Ayudha Puja, Varamahalakshmi, Ganesha visarjana afternoon, thread ceremony lunches.',
  nutrition_notes = 'High plant protein when sprouted; hydrating; low calorie counter to fried sweets.',
  best_season = 'Summer festivals; Navaratri peak.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-KA' AND f.food_name = 'Kosambari';

UPDATE public.food_state_items f SET
  short_description = 'Avial: coconut–yogurt vegetable aviyal—Onam sadya and Kerala temple oottupura essential, tracing to Bhima/Ulli legend in Malayali culinary lore.',
  about_food = 'Sadya''s moral is inclusivity: many vegetables one gravy, like many jatis one dharma. Curd version is tamarind-free for certain Shaiva fast days.',
  history = 'Bhagavata and local sthala puranas link aviyal to hurried feast cooking; Nambudiri and Ambalavasi kitchens refined proportions.',
  ingredients = 'Raw banana, yam, ash gourd, drumstick, beans, carrot (modern), coconut paste, cumin, green chilli, coconut oil, curry leaves; curd or raw mango souring.',
  preparation_style = 'Cook veg to bite, fold coconut paste, simmer, finish with beaten curd off heat and coconut oil crackling.',
  serving_context = 'Onam, Vishu, temple utsava oonu, wedding sadya on banana leaf center-right position.',
  nutrition_notes = 'Fiber spectrum; coconut medium-chain fats; watch portion with hyperlipidemia.',
  best_season = 'Onam (Chingam); monsoon veg abundance.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-KL' AND f.food_name = 'Avial';

UPDATE public.food_state_items f SET
  short_description = 'Palada payasam: milk-reduced rice ada kheer—Guruvayur and Sabarimala prasadam culture, neivedhya for Vishu kani and birthday nakshatra homams.',
  about_food = 'Ada (rice flake strips) symbolizes woven offerings; slow reduction of milk is tapas in kitchen form. Temple counters sell by weight as punya dravya.',
  history = 'Palaces and mathas competed in payasam thickness; pressure-cooker shortcuts now debated in orthodox homes.',
  ingredients = 'Rice ada, full-fat milk, sugar or jaggery, ghee, cardamom, cashews, raisins.',
  preparation_style = 'Fry ada in ghee, simmer in milk until pink and thick, sweeten, garnish.',
  serving_context = 'Vishu kani first sighting meal, Thiruvonam sadya sweet, seva after Bhagavata saptaha.',
  nutrition_notes = 'Calcium and energy; lactose and sugar sensitive adjust.',
  best_season = 'Festival calendar; year-round in temples.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-KL' AND f.food_name = 'Palada Payasam';

UPDATE public.food_state_items f SET
  short_description = 'Dal bafla: wheat dough ball boiled then baked, crushed with ghee and dal—Malwa''s echo of Rajasthan baati and Maratha camp kitchens, festival food of Mahakaleshwar pilgrims.',
  about_food = 'Panchamrita-like ghee pour transforms plain ball into prasad texture; eaten after darshan of Jyotirlinga routes.',
  history = 'Central Indian plateau wheat–gram economy; Simhastha Kumbh stalls normalize mega-batch bafla.',
  ingredients = 'Wheat atta, coarse semolina, fennel, salt; toor dal; ghee, cumin, hing, garlic optional (sattvic omit).',
  preparation_style = 'Shape balls, boil till floating, bake or roast crisp, crush, drench ghee; serve dal tempered.',
  serving_context = 'Ujjain darshan meals, rural weddings, Govardhan puja annakut analogues.',
  nutrition_notes = 'High satiety; ghee calories; dal protein balance.',
  best_season = 'Year-round; Kumbh peaks.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-MP' AND f.food_name = 'Dal Bafla';

UPDATE public.food_state_items f SET
  short_description = 'Bhutte ka kees: grated monsoon corn cooked with milk and mild spice—Malwa harvest gratitude to Indra and field mothers, street food outside Indore temples.',
  about_food = 'Eaten during Adhik Maas simple dinners and Teej; corn''s gold ties to Lakshmi color symbolism in folk songs.',
  history = 'Pre-Green Revolution corn variety memory; now a city identity dish with sev topping optional.',
  ingredients = 'Fresh sweet corn grated, milk, ghee, mustard, green chilli, turmeric, lemon, coriander; sugar optional.',
  preparation_style = 'Saute corn, simmer with milk to creamy scramble texture, finish lemon.',
  serving_context = 'Rakhi afternoon snack, Ganesh visarjan return meal light dish.',
  nutrition_notes = 'Fiber and B vitamins; watch added sugar.',
  best_season = 'Monsoon corn (July–September).',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-MP' AND f.food_name = 'Bhutte ka Kees';

UPDATE public.food_state_items f SET
  short_description = 'Puran poli: thin wheat roti with chana–jaggery puran—Gudi Padwa, Holi, and Akshaya Tritiya naivedyam; toran and poli embody sweet new year in Marathi Hindu homes.',
  about_food = 'Served with ghee and milk or amti; some lineages offer first poli to tulsi before family. Puran''s lentil base makes it substantial prasad unlike only-sugar sweets.',
  history = 'Maratha court and Desh–Konkan variants differ in kesar and nutmeg; diaspora Ganesh utsav in USA features puran poli as cultural sacrament.',
  ingredients = 'Wheat or maida–atta mix, chana dal, jaggery, cardamom, nutmeg, ghee, turmeric cloth dye optional for yellow poli.',
  preparation_style = 'Cook dal soft, sweeten and reduce puran, stuff thin roti, dry-roast with ghee till spotted.',
  serving_context = 'Gudi Padwa puja, Holi dhapate meal, wedding mehndi night, Satyanarayan katha conclusion.',
  nutrition_notes = 'Protein from chana; jaggery iron; carb heavy—diabetics moderate.',
  best_season = 'Spring festivals; year-round for kathas.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-MH' AND f.food_name = 'Puran Poli';

UPDATE public.food_state_items f SET
  short_description = 'Sabudana khichdi: tapioca pearls with peanut and potato—Maharashtra Ekadashi and Mahashivaratri vrata anchor dish; sago as allowed farali grain.',
  about_food = 'Categorized under phalahar alongside rajgira; offered to Vishnu in fast-breaking thali. Peanuts stand in for dals when legumes are barred.',
  history = 'Colonial-era sago trade made it affordable vrata food; cookbook standardization by urban gharanas.',
  ingredients = 'Soaked sabudana, potato cubes, roasted peanut powder, cumin, green chilli, curry leaves, ghee, lemon, rock salt.',
  preparation_style = 'Minimal water toss-cook to separate pearls; finish lemon and coriander.',
  serving_context = 'Ekadashi, Pradosh, Mahashivaratri night meal, Ganesh Chaturthi farali thali.',
  nutrition_notes = 'Quick starch energy; peanuts add protein; low fiber—pair with yogurt if permitted.',
  best_season = 'Year-round vrata calendar.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-MH' AND f.food_name = 'Sabudana Khichdi';

UPDATE public.food_state_items f SET
  short_description = 'Chakhao kheer: black rice (Forbidden rice) milk pudding—Manipuri Lai Haraoba and Ras festival dessert; rice''s purple as royal offering to ancestors.',
  about_food = 'Chakhao is GI rice; in Vaishnav Manipur it joins ritual feasts with vegetarian discipline. Color evokes Krishna''s dark complexion in local bhakti imagination.',
  history = 'Meitei kingship agricultural prestige; today national superfood branding meets ancient ritual.',
  ingredients = 'Black glutinous rice, milk, jaggery or sugar, cardamom, bay leaf, nuts.',
  preparation_style = 'Soak rice, slow simmer in milk until anthocyanin bleeds purple–mauve, sweeten, thicken.',
  serving_context = 'Ningol Chakouba sweets spread, temple donation meals, wedding night dessert.',
  nutrition_notes = 'Anthocyanin antioxidants; calcium from milk; sugar control portions.',
  best_season = 'Festival months; winter kheer comfort.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-MN' AND f.food_name = 'Chakhao Kheer';

UPDATE public.food_state_items f SET
  short_description = 'Pumaloi: steamed rice powder mound—Khasi jaintia sacred feasts (ka kot) and Hindu-adjacent community meals; grain offered before meat courses in blended traditions.',
  about_food = 'Symbol of collective rice sovereignty; served on banana leaf with tungrymbai or vegetarian sides during interfaith hill gatherings.',
  history = 'Pre-Christian oral protocols; church feasts adapted pumaloi as neutral starch base.',
  ingredients = 'Roasted rice flour, water, salt.',
  preparation_style = 'Moisten flour to crumb, steam in cloth-lined pot till fluffy mountain, break by hand.',
  serving_context = 'Shad suk mynsiem, harvest thanksgiving, Hindu–Christian wedding buffets in Shillong.',
  nutrition_notes = 'Plain carb; pair with protein and greens.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-ML' AND f.food_name = 'Pumaloi';

UPDATE public.food_state_items f SET
  short_description = 'Bai: Mizo boiled greens and roots stew—adapted to Christian-majority tables but appears in Hindu vegetarian households during sacred simplicity fasts.',
  about_food = 'Shares logic with North East boiled clean taste (jain-adjacent) meals; bamboo shoot variant ties to forest dharma of non-waste.',
  history = 'Pre-missionary food; now documented in Mizoram handicraft–food tourism.',
  ingredients = 'Mustard leaves, pumpkin, beans, bamboo shoot, chilli, ginger, water, minimal oil.',
  preparation_style = 'Simmer until soft, adjust salt; no heavy masala.',
  serving_context = 'Community clean-food days, Sunday fellowship vegetarian option, yoga retreat hill menus.',
  nutrition_notes = 'Low calorie high micronutrient; bamboo shoot sodium.',
  best_season = 'Monsoon greens peak.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-MZ' AND f.food_name = 'Bai';

UPDATE public.food_state_items f SET
  short_description = 'Sticky rice cake: glutinous rice steamed in leaf with sesame–jaggery—Naga festival cakes for Moatsu, Tokhu Emong, shared across Christian and traditional rites.',
  about_food = 'Parallel to Assamese pitha grammar; in Hindu Naga homes offered during Lakshmi puja adaptations with local names.',
  history = 'Headhunting-era victory feasts evolved into harvest sharing; Hornbill Festival demo batches.',
  ingredients = 'Glutinous rice flour or whole grain, jaggery, sesame, banana leaf.',
  preparation_style = 'Wrap and steam 30–40 minutes; cool before unwrapping.',
  serving_context = 'Village gate feasts, church harvest thanksgiving, Hornbill cultural stalls.',
  nutrition_notes = 'Dense energy; gluten-free.',
  best_season = 'Harvest (October–November).',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-NL' AND f.food_name = 'Sticky Rice Cake';

UPDATE public.food_state_items f SET
  short_description = 'Dalma: lentil–vegetable stew without onion–garlic—Jagannath temple mahaprasad cousin for home kitchens, embodying Odia sattvik ahara.',
  about_food = 'Pancha phala (five fruits) variants for certain utsavas; banana stem and raw papaya echo Ayurvedic shodhana. Served as first solid with rice after abhisheka meals.',
  history = 'Car festival kitchens scale dalma in tonnage; poet-saints sang of mahaprasad egalitarianism.',
  ingredients = 'Toor or moong dal, raw papaya, plantain, pumpkin, elephant foot yam (with care), drumstick, panch phoron, ginger, ghee, coconut optional.',
  preparation_style = 'Pressure cook dal–veg, temper panch phoron in ghee, fold, simmer, finish coconut if used.',
  serving_context = 'Lakshmi Puja Odisa homes, Kartik month brata, Puri pilgrim return cooking.',
  nutrition_notes = 'High fiber; protein from dal; low fat if ghee modest.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-OR' AND f.food_name = 'Dalma';

UPDATE public.food_state_items f SET
  short_description = 'Khiri: Odia slow milk–rice kheer with bay leaf and cardamom—naivedyam on birthdays, bratas, and Manabasa Gurubar Lakshmi vrata.',
  about_food = 'Thinner than North Indian kheer sometimes; jaggery khiri for certain deities. Rice grain intact as symbol of aksata (unbroken blessing).',
  history = 'Temple records of rice land grants tied to khiri sevas; coastal Odisha adds coconut milk variants.',
  ingredients = 'Govind bhog or short rice, milk, sugar or jaggery, cardamom, bay leaf, cashews, raisins, ghee.',
  preparation_style = 'Simmer rice in milk low flame, stir to prevent burn, sweeten when soft, garnish.',
  serving_context = 'Kartik brata, Saraswati puja, funeral shraddha sweet course (gotra variations).',
  nutrition_notes = 'Calcium and energy; use jaggery for lower GI than refined sugar.',
  best_season = 'Festival dense; year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-OR' AND f.food_name = 'Khiri';

UPDATE public.food_state_items f SET
  short_description = 'Makki roti with sarson saag: maize flatbread and mustard greens—Lohri, Maghi, and Vaisakhi agrarian sacrament; bonfire and saag tie to sun–earth gratitude.',
  about_food = 'Sikh panth popularized globally but roots lie in Hindu Punjabi winter kitchens; white butter (white) on saag echoes snow–prosperity folk metaphor.',
  history = 'Green Revolution changed wheat ratio but makki–sarson remains ritual winter dyad; Gurdaspur–Amritsar belt iconic.',
  ingredients = 'Makki atta, water, ghee; sarson + palak + bathua greens, ginger, green chilli, makki flour slurry optional, white butter.',
  preparation_style = 'Hand-press roti between palms, cook on tawa with ghee; slow-cook greens mashed with tadka.',
  serving_context = 'Lohri dinner, Maghi mela, Gurpurab langar crossover, Hindu wedding winter lunch in villages.',
  nutrition_notes = 'Iron and calcium from greens; maize niacin; heavy—portion control.',
  best_season = 'Winter greens (December–February).',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-PB' AND f.food_name = 'Makki Roti with Sarson Saag';

UPDATE public.food_state_items f SET
  short_description = 'Panjiri: roasted wheat flour, ghee, sugar, nuts, gum arabic—Janmashtami prasad, postpartum stri-rittis, and Hanuman Tuesday bhog across North India.',
  about_food = 'Sattvic strength food (balya) in Ayurvedic folk use; distributed at Bhagavata katha breaks. Edible gum signifies bone-joint blessing symbolism in grandmother lore.',
  history = 'Punjab–Haryana wheat belt; packaged panjiri for prasad flights to diaspora.',
  ingredients = 'Whole wheat flour, ghee, boora or powdered sugar, makhana, melon seeds, gond, almonds, cashews, cardamom.',
  preparation_style = 'Roast flour in ghee to nutty brown, puff gond separately, mix sweet and nuts off heat.',
  serving_context = 'Krishna janmostav, Seemantham gifts, Sitala Mata vrata, winter pilgrim prasad.',
  nutrition_notes = 'Very energy dense; nuts and gond fats; diabetics use jaggery sparingly.',
  best_season = 'Winter and festival peaks.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-PB' AND f.food_name = 'Panjiri';

UPDATE public.food_state_items f SET
  short_description = 'Dal baati churma: Rajasthan''s triad—baked wheat ball, panchmel dal, sweet crushed churma—feast of Thar courage, goddess festivals, and temple bhandaras.',
  about_food = 'Baati''s desert dryness met ghee soak as luxury; churma''s jaggery version offered to local deities on Teej. Symbolizes full cycle: savory sustenance and sweet dharma.',
  history = 'Rajput campaign food; Marwari diaspora globalized the meal as Rajasthani thali.',
  ingredients = 'Atta baati coarse wheat, ghee; mixed dals; churma whole wheat, ghee, jaggery or sugar, cardamom.',
  preparation_style = 'Bake baati in cow dung or oven till hard shell, crush with ghee; pressure dals; roast churma and bind sweet.',
  serving_context = 'Teej, Gangaur return feast, wedding sangeet dinner vegetarian option, Salasar Balaji annadanam.',
  nutrition_notes = 'High calorie desert fuel; hydration important; legume protein balances.',
  best_season = 'Cooler months; festivals year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-RJ' AND f.food_name = 'Dal Baati Churma';

UPDATE public.food_state_items f SET
  short_description = 'Ghevar: lacy disc fried and syrup-soaked—Teej, Rakhi, and Savan Somvar sweets; honeycomb as monsoon cloud metaphor in Rajasthani poetry.',
  about_food = 'Married women''s fasting gifts; rabri-topped ghevar as urban luxury. Krishna janmashtami variants appear in Jaipur mithai shops.',
  history = 'Royal kitchens refined thickness; now mass-produced for seasonal windows.',
  ingredients = 'Maida batter, ghee deep-fry, sugar syrup, saffron, rabri topping optional, silver vark.',
  preparation_style = 'Pour batter in hot ghee in ring mould for vertical rise, soak syrup lightly, top rabri.',
  serving_context = 'Hariyali Teej, Raksha Bandhan brother gifts, Shravan temple fairs.',
  nutrition_notes = 'Occasional festive sugar–fat bomb.',
  best_season = 'Monsoon (Shravan–Bhadrapada).',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-RJ' AND f.food_name = 'Ghevar';

UPDATE public.food_state_items f SET
  short_description = 'Sel roti: rice batter ring fried crisp-soft—Nepali Dashain–Tihar axis adopted by Sikkim Hindu homes; bread as mandala offering at household shrines.',
  about_food = 'Prepared in batches for lekhapan (lineage plate) offerings; shared with neighbors as punya. Buddhist–Hindu overlap in Himalayan kitchens.',
  history = 'Gurkha regimental culture spread recipe across India; Sikkim statehood integrated it in school cultural days.',
  ingredients = 'Rice soaked, sugar, ghee or milk, cardamom, baking optional.',
  preparation_style = 'Grind to thick batter, ferment lightly, hand-pour rings in medium oil.',
  serving_context = 'Dashain tika, Losar neighborhood exchange, wedding morning in Gangtok.',
  nutrition_notes = 'Fried carb; fermentation aids digestion slightly.',
  best_season = 'Autumn festival cluster.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-SK' AND f.food_name = 'Sel Roti';

UPDATE public.food_state_items f SET
  short_description = 'Sakkarai pongal: jaggery pongal with ghee and cashews—Thai Pongal boiling-over pot as sun worship, Tamil harvest thanksgiving to Surya and cattle.',
  about_food = 'Kolam around new pot, turmeric sugarcane arch, shout pongalo pongal at overflow—embodied Vedic gratitude to anna. Temples offer as prime sweet naivedyam.',
  history = 'Sangam poetry to Green Revolution; global Tamil diaspora Pongal reduces pot ritual to electric stove with same mantras.',
  ingredients = 'Raw rice, moong dal, jaggery, ghee, cashews, raisins, cardamom, edible camphor pinch, nutmeg.',
  preparation_style = 'Cook dal–rice soft, dissolve jaggery, merge, simmer, ghee temper dry fruits.',
  serving_context = 'Thai Pongal, temple kumbabishekam annadanam, housewarming subh muhurta.',
  nutrition_notes = 'Festive energy; calcium from jaggery types varies.',
  best_season = 'Thai month (mid-January).',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-TN' AND f.food_name = 'Sakkarai Pongal';

UPDATE public.food_state_items f SET
  short_description = 'Kozhukattai: steamed rice flour dumpling—Vinayaka Chaturthi primary naivedyam; modak mythology as Ganapati''s favorite from Anusuya-Shiva lore.',
  about_food = 'Sukiyan-style sweet poornam and ulundu savory variants; count 21 or 108 for archana offerings. Kolukattai plate arranges with banana and coconut.',
  history = 'Silappatikaram references; Chettiar and Brahmin styles differ in coconut–jaggery ratio.',
  ingredients = 'Rice flour dough with hot water, coconut–jaggery filling, sesame, cardamom; savory: urad spiced.',
  preparation_style = 'Stuff crescent moulds, steam 10–12 minutes on banana leaf base.',
  serving_context = 'Ganesh Chaturthi, Avani avittam sweet side, Aadi perukku picnic.',
  nutrition_notes = 'Steamed lower fat than fried modak; sweet version sugar load.',
  best_season = 'Bhadrapada Chaturthi; year-round in temples.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-TN' AND f.food_name = 'Kozhukattai';

UPDATE public.food_state_items f SET
  short_description = 'Sakinalu: crispy rice-flour spirals—Telangana Sankranti women''s craft snack, exchanged in atta garu boxes as sangam of families.',
  about_food = 'Made in courtyard groups while singing sankranti songs; sesame and ajwain echo digestive mantras for heavy festival eating.',
  history = 'Deccan plateau rice culture; same grammar as chegodilu and murukku family.',
  ingredients = 'Rice flour, water, salt, sesame, ajwain, chilli powder optional, hot oil to fry.',
  preparation_style = 'Knead tight dough, coil on wooden stick or hand spiral, fry low–medium for even crisp.',
  serving_context = 'Makara Sankranti, Bhogi fire night munching, wedding return gifts.',
  nutrition_notes = 'Fried snack; sesame minerals.',
  best_season = 'Harvest / Sankranti.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-TS' AND f.food_name = 'Sakinalu';

UPDATE public.food_state_items f SET
  short_description = 'Telangana pulihora: tamarind rice with regional temper nuance—Bhadrachalam Rama temple prasadam culture and domestic Satyanarayana seva staple.',
  about_food = 'Often drier and redder than Andhra cousin; peanut forward. Distributed at kalyanam as travel-stable blessed food.',
  history = 'Nizam-era urban temples continued Vaishnava prasadam lines; today IT diaspora carries frozen pulikachal.',
  ingredients = 'Rice, thick tamarind, sesame oil, mustard, chana dal, urad dal, curry leaf, dry chilli, turmeric, peanuts, roasted sesame powder.',
  preparation_style = 'Prepare pulikachal concentrate; mix cooled rice; rest for flavor meld.',
  serving_context = 'Hanuman jayanthi, Sravana Shanivaram, picnic prasad after homam.',
  nutrition_notes = 'Similar to pulihora; shelf-stable acid profile.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-TS' AND f.food_name = 'Pulihora (Telangana Style)';

UPDATE public.food_state_items f SET
  short_description = 'Awandru: colocasia stem curry—Tripura Hindu vegetarian adaptation of Kokborok cuisine for vrata days honoring forest tuber deities.',
  about_food = 'Calcium oxalate handling (itch) taught as matrilineal kitchen knowledge; offered in Lakshmi vrata as taro-family sattvic variant when prepared correctly.',
  history = 'Royal Tripura thali included indigenous veg; post-merger Bengali influence added panch phoron notes.',
  ingredients = 'Colocasia stem, rice flour slurry, ginger, green chilli, turmeric, mustard oil or coconut oil.',
  preparation_style = 'Boil stems well, simmer with spiced paste; thicken with rice slurry.',
  serving_context = 'Ambubachi-like local observances, full-moon vegetarian thalis.',
  nutrition_notes = 'Rich in minerals; must be cooked through to reduce oxalate irritation.',
  best_season = 'Monsoon taro growth.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-TR' AND f.food_name = 'Awandru';

UPDATE public.food_state_items f SET
  short_description = 'Kachori sabzi: urad-dal-stuffed fried bread with potato–spice gravy—Kashi, Mathura, and Lucknow morning pilgrimage breakfast; tirtha energy meal before long darshan queues.',
  about_food = 'Differs from Rajasthan dry kachori; UP variant is softer, paired with runny aloo. Served after Ganga snan as punya ahara.',
  history = 'Nawabi city bazaars Hinduized the combo for vegetarian majority; train stations spread pattern.',
  ingredients = 'Maida–atta, urad dal paste spiced, potato, tomato, asafoetida, amchur, coriander.',
  preparation_style = 'Stuff, fry fluffy; sabzi boiled potato gravy with poori masala notes.',
  serving_context = 'Mangala aarti exit meals, Upanayana mornings, Sunday bazaar after temple.',
  nutrition_notes = 'Occasional heavy breakfast; legume stuffing helps protein.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-UP' AND f.food_name = 'Kachori Sabzi';

UPDATE public.food_state_items f SET
  short_description = 'Mathura peda: caramelized khoya discs—Shri Krishna janmabhoomi prasad archetype; dhoodh peda as bhog for Laddu Gopal at home altars.',
  about_food = 'Grainy vs smooth peda marks shop lineage; offered in multiples of 11 or 21 for katha sankhya. Braj bhakti poetry ties milk sweets to Krishna''s childhood dairy lore.',
  history = 'Temple economies scaled khoya production; rail cooled transport made Mathura a brand.',
  ingredients = 'Khoya, sugar, cardamom, saffron, ghee for hand-shaping.',
  preparation_style = 'Roast khoya with sugar to fudge stage, beat slightly grainy, mould while warm.',
  serving_context = 'Janmashtami, Tulsi vivah, Govardhan puja annakut alongside peda mounds.',
  nutrition_notes = 'Calcium and protein from milk solids; sugar dense.',
  best_season = 'Festival calendar; Braj yatra peaks.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-UP' AND f.food_name = 'Mathura Peda';

UPDATE public.food_state_items f SET
  short_description = 'Kafuli: Garhwali spinach–fenugreek puree curry with rice flour slurry—mountain sattvic green offering on Shivaratri and local devta yatra returns.',
  about_food = 'Yogurt or buttermilk variants; no onion–garlic in ritual form. Represents pahadi use of wild greens (lai) as prasad of the hills.',
  history = 'Chipko-era women''s knowledge of edible weeds intersects with kafuli ingredients.',
  ingredients = 'Palak, methi or local lsaun leaves, rice flour or chickpea flour, yogurt optional, mustard oil, green chilli, ginger.',
  preparation_style = 'Boil greens, puree, simmer with slurry, temper jeera in oil.',
  serving_context = 'Harela festival, Shiv ratri vrata end, post-Kedarnath trek home meal.',
  nutrition_notes = 'Iron folate rich; mustard oil omega-3.',
  best_season = 'Spring greens; monsoon foraging.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-UK' AND f.food_name = 'Kafuli';

UPDATE public.food_state_items f SET
  short_description = 'Jhangora kheer: barnyard millet pudding—Kumaon Navaratri vrata and Kedarnath yatra stamina food; millet as older Himalayan grain than rice.',
  about_food = 'Permitted in many ekadashi interpretations; offered to Nanda Devi in local nandaashtami contexts as sweet cereal.',
  history = 'Millet decline with rice subsidies; revival via Pahadi slow food NGOs.',
  ingredients = 'Jhangora millet, milk, jaggery, cardamom, nuts, ghee.',
  preparation_style = 'Toast millet lightly, simmer in milk until swell and creamy, sweeten.',
  serving_context = 'Garhwal weddings vrata menu, yoga ashram Kumaon retreats.',
  nutrition_notes = 'Gluten-free; fiber rich; calcium if milk heavy.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-UK' AND f.food_name = 'Jhangora Kheer';

UPDATE public.food_state_items f SET
  short_description = 'Shukto: bitter-first Bengali vegetable prelude—wedding bou bhat and Durga puja bijoya dashami vegetarian course embodying six tastes (shad rasa) as life philosophy.',
  about_food = 'Uchhe (bitter gourd) honors medicinal rasa opening meal; panch phoron links to Vaishnava Bengal; some families forbid onion for deva days.',
  history = 'Colonial cookbook modernization; Tagore household menus documented shukto as civility.',
  ingredients = 'Bitter gourd, raw banana, drumstick, potato, sweet potato, brinjal, milk, ginger, radhuni or panch phoron, poppy–mustard paste optional.',
  preparation_style = 'Fry bitter separately, cook veg in sequence, light milk finish, never chilli-hot.',
  serving_context = 'Poila Boishakh lunch, Annaprashan family feast opener, Kali puja bhog thali start.',
  nutrition_notes = 'Digestive bitters; fiber diverse; watch dairy fat.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-WB' AND f.food_name = 'Shukto';

UPDATE public.food_state_items f SET
  short_description = 'Narkel naru: coconut–jaggery ladoo—Lakshmi puja, Kali puja, and Jagaddhatri prasad balls rolled while mantras are chanted.',
  about_food = 'Bengali women''s collective kitchen production; naru given to daughters as auspicious return gift. Coconut as Lakshmi''s hair metaphor in folk song.',
  history = 'Navanna rice-to-sweet transition festival links; Sylheti diaspora carries naru to UK pujas.',
  ingredients = 'Fresh grated coconut, jaggery, cardamom, ghee touch, camphor optional.',
  preparation_style = 'Cook coconut with jaggery to dry fudge, roll while warm, cool hard.',
  serving_context = 'Kojagari Lakshmi brata, Durga bijoya sindoor khela snack trays.',
  nutrition_notes = 'Minerals from jaggery; saturated fat from coconut.',
  best_season = 'Autumn festival cluster (Ashwin–Kartik).',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-WB' AND f.food_name = 'Narkel Naru';

UPDATE public.food_state_items f SET
  short_description = 'Coconut rice prasadam: thengai sadam island variant—Andaman temple festivals blending Tamil–Bengali coastal naivedyam with abundant narikel.',
  about_food = 'Offered at Subramanya and Devi shrines in Port Blair; mild temper evokes Kerala–Karnataka tengina anna transported to bay geography.',
  history = 'Post-1950 settler temples adapted mainland recipes to local coconut varieties.',
  ingredients = 'Rice, grated coconut, coconut oil, mustard, urad dal, chana dal, curry leaf, cashew, green chilli, hing.',
  preparation_style = 'Cook rice separate, temper spices in coconut oil, fold coconut grate, mix fluffy.',
  serving_context = 'Island temple kumbhabhishekam, Thai Pongal diaspora, Navy Housing colony pujas.',
  nutrition_notes = 'MCFA from coconut; steady carbs.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-AN' AND f.food_name = 'Coconut Rice Prasadam';

UPDATE public.food_state_items f SET
  short_description = 'Atta pinni: whole-wheat roasted ladoo with ghee and nuts—North Indian winter prasad, Sikh–Hindu shared langar-adjacent sweet at Chandigarh gurdwaras and mandirs.',
  about_food = 'Given to new mothers and students before exams as ashirvad; Lohri throw pinni alongside popcorn. Embodies anna shakti from roasted grain.',
  history = 'Punjab wheat belt; army cantonment mess adapted pinni as energy bar.',
  ingredients = 'Atta, ghee, boora sugar, almonds, cashews, edible gum, cardamom.',
  preparation_style = 'Slow roast atta to copper color, bind warm with sugar syrup or boora, shape ladoos.',
  serving_context = 'Makar Sankranti, Seemantham, Satyanarayan katha, Gurpurab community trays.',
  nutrition_notes = 'Very dense; nuts add micronutrients.',
  best_season = 'Winter.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-CH' AND f.food_name = 'Atta Pinni';

UPDATE public.food_state_items f SET
  short_description = 'Dudh pak: slow-reduced milk–rice with saffron—Gujarati–Daman wedding prasad and vrata dessert; kheer cousin served at Satyanarayan in coastal UT homes.',
  about_food = 'Saffron threads evoke solar purity; silver vark optional. Hindu families in Daman merge Portuguese dessert plating with Indian katha rituals.',
  history = 'Portuguese Goa–Daman sweet milk traditions hybridized with Gujarati kheer methods.',
  ingredients = 'Full milk, basmati rice, sugar, saffron, cardamom, almonds, pistachio, charoli.',
  preparation_style = 'Simmer milk hours, add soaked rice, reduce to thick pink cream, nuts on top.',
  serving_context = 'Ganesh sthapana, Navaratri jagran night, Christmas-season interfaith parties in UT.',
  nutrition_notes = 'High calcium dessert; sugar load.',
  best_season = 'Festivals; wedding season.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-DN' AND f.food_name = 'Dudh Pak';

UPDATE public.food_state_items f SET
  short_description = 'Bedmi puri aloo: urad-stuffed crisp puri with spiced potato—Delhi pilgrimage breakfast from Old Shahjahanabad, eaten after Jama Masjid–area walks and Chandni Chowk festivals for Hindu shoppers.',
  about_food = 'Karva Chauth morning sargi-adjacent in some families; Hanuman temple Tuesdays near Fatehpuri. Represents Mughal city''s Hindu vegetarian street genius.',
  history = 'Partition refugees sustained stalls; now Instagram queue food.',
  ingredients = 'Atta, soaked urad paste, hing, cumin, potato, tomato, amchur, red chilli.',
  preparation_style = 'Stuff, roll thick, fry; sabzi thin gravy with kasuri methi optional.',
  serving_context = 'Diwali morning, wedding baraat departure snack, weekend heritage food walks.',
  nutrition_notes = 'Heavy; urad protein; occasional meal.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-DL' AND f.food_name = 'Bedmi Puri Aloo';

UPDATE public.food_state_items f SET
  short_description = 'Rajma gogji: kidney beans with turnip—Jammu Dogra winter shakahari khana; shivratri and sankranti household curry linking legume and root to mountain storage economy.',
  about_food = 'No onion–garlic variants for vrata; yogurt garnish optional. Turnip (gogji) is rabi blessing in Pahadi songs.',
  history = 'Dogra palace kitchens to army mess vegetarian option.',
  ingredients = 'Rajma soaked, turnip cubes, ginger, cumin, coriander powder, asafoetida, mustard oil or ghee.',
  preparation_style = 'Pressure cook together, simmer gravy, finish garam masala and coriander.',
  serving_context = 'Maha Shivaratri family lunch, Vaishno Devi return meal, Lohri vegetarian plate.',
  nutrition_notes = 'Protein iron combo; fiber rich.',
  best_season = 'Winter turnip harvest.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-JK' AND f.food_name = 'Rajma Gogji';

UPDATE public.food_state_items f SET
  short_description = 'Khambir with ghee: fermented whole-wheat Ladakhi round bread—monastery guest hospitality and Losar vegetarian meals alongside butter tea.',
  about_food = 'Served to pilgrims at Hemis and Diskit as sustaining carb; ghee dip echoes butter lamp offering symbolism in folk hospitality dharma.',
  history = 'Yeast from chang or commercial now; climate change shortens fermentation predictability.',
  ingredients = 'Whole wheat, sourdough starter or yeast, salt, water, ghee to serve.',
  preparation_style = 'Ferment dough, hand-flatten, griddle-bake thick, char slightly, brush ghee.',
  serving_context = 'Losar family breakfast, wedding vegetarian day, trekker homestays.',
  nutrition_notes = 'High altitude energy needs; gluten present.',
  best_season = 'Cold months; year-round in Leh.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-LA' AND f.food_name = 'Khambir with Ghee';

UPDATE public.food_state_items f SET
  short_description = 'Coconut jaggery ladoo: island narikel–gur naru—Lakshadweep Eid-adjacent and Hindu home puja sweet; coconut palm as kalpavriksha in coastal Sanskrit imagination.',
  about_food = 'Prepared for Auspicious Friday prayers and ship-return thanksgiving; jaggery from mainland meets local coconut.',
  history = 'Malayali Muslim island culture with Hindu neighbour overlap; craft women roll ladoos for coop export.',
  ingredients = 'Grated coconut, jaggery, cardamom, ghee.',
  preparation_style = 'Reduce together to dry, roll, cool.',
  serving_context = 'Island weddings, Chandanakudam processions sweet packets, monsoon home rituals.',
  nutrition_notes = 'Mineral sweet; saturated fat awareness.',
  best_season = 'Year-round.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-LD' AND f.food_name = 'Coconut Jaggery Laddoo';

UPDATE public.food_state_items f SET
  short_description = 'Puliyodarai: Tamil temple tamarind rice prasadam—Manakula Vinayagar and French-era Puducherry shrines distribute as travel packet blessed food (kumbakonam-style pulikaichal).',
  about_food = 'Tied to Sri Vaishnava kshetras; sesame oil is doctrinally preferred; pulikaichal jar gifted at upanayanam as symbolic sustained bhakti.',
  history = 'Tamil diaspora from Pondy carries recipe; Auroville organic cafés veganize variant.',
  ingredients = 'Rice, pulikaichal (tamarind concentrate fried with spices), sesame oil, mustard, dals, peanut, curry leaf, turmeric, hing.',
  preparation_style = 'Make shelf-stable paste; mix cold rice; lasts days—ideal prasad logistics.',
  serving_context = 'Karthigai Deepam, Panguni utsav, Manakula Vinayagar car procession.',
  nutrition_notes = 'Stable lipids; probiotic-free but tamarind sour preserves.',
  best_season = 'Year-round temple calendar.',
  updated_at = now()
FROM public.food_state_hubs h
WHERE f.hub_id = h.id AND h.state_code = 'IN-PY' AND f.food_name = 'Puliyodarai';
