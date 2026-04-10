-- Expand narrative fields for Indian classical / state-classical dances
-- (cultural_state_items where hub category = classical_dance).
-- Does NOT touch cover_image_url or gallery_urls.

UPDATE public.cultural_state_items i SET
  short_description = 'Kuchipudi: Andhra''s dance-drama tradition blending pure dance (jatis), mime (abhinaya), and spoken dialogue—famous for Tarangam (dancing on brass plate) and nimble footwork.',
  about_state_tradition = 'The village of Kuchipudi gave the form its name; today Hyderabad, Vijayawada, and Chennai host major schools. Repertoire includes darus, sabdam, varnam, and yakshagana-style pravesha daruvus. Carnatic music (violin, mridangam, nattuvangam) structures performance.',
  history = 'Bhagavata Mela links and Siddhendra Yogi hagiography anchor origin stories; 20th-century reform moved solo female presentation from hereditary male troupes; Sangeet Natak Akademi recognition solidified classical status.',
  cultural_significance = 'Telugu sahitya (Kshetrayya, Narayana Teertha) lives in abhinaya; diaspora sabhas feature Kuchipudi alongside Bharatanatyam.',
  practice_and_pedagogy = 'Adavu clusters, chari–bhramari theory, hasta from Abhinaya Darpana, nattuvangam conducting, and stamina for fast jatis. University B.Mus./MFA programmes standardize syllabi.',
  performance_context = 'Nrityotsav, Hyderabad arts fests, Music Academy Chennai, global Indian classical circuits.',
  notable_exponents = 'Vempati Chinna Satyam lineage; Yamini Krishnamurthy; Shanta Rao; contemporary gurus in India and USA.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-AP' AND i.item_name = 'Kuchipudi';

UPDATE public.cultural_state_items i SET
  short_description = 'Ponung: Adi and allied community dance led by female chorus and male Miri (mithun horn) players—spiral formations honouring agricultural spirits and heroes.',
  about_state_tradition = 'Performed at Solung, Mopin, and harvest events in East Siang and Lower Dibang; brass plates, gongs, and call-and-response chanting drive tempo. Costumes feature galuk (headgear) and shell jewellery.',
  history = 'Oral clan histories tie Ponung to migration and land clearance; state cultural academies choreograph stage adaptations for Republic Day while villages retain longer night cycles.',
  cultural_significance = 'Visible expression of indigenous identity versus pan-Indian classical canon; gendered roles in who leads circle entry.',
  practice_and_pedagogy = 'Youth learn by joining chorus; horn and drum apprenticeships separate; tourism packages sometimes shorten ritual pacing.',
  performance_context = 'Itanagar festivals, Ziro music festival sidelines, North East cultural exchanges.',
  notable_exponents = 'Adi Cultural & Literary Society troupes; state-sponsored repertory dancers.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-AR' AND i.item_name = 'Ponung Classicalized Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Sattriya: Assam''s monastery-born classical dance—Ojapali narrative roots, mati akhara floor exercises, and ankiya bhaona-derived abhinaya in white and gold attire.',
  about_state_tradition = 'Satra institutions (Kamalabari, Uttar Kamalabari) train male and now female dancers; instruments include khol, taal, and bamboo flute. Repertoire: nandi, rasa dances, and Krishna–Radha episodes.',
  history = 'Sankardeva and Madhavdeva''s fifteenth–sixteenth century reform; 2000 Sangeet Natak Akademi classical recognition; UNESCO broader Vaishnav intangible heritage discourse.',
  cultural_significance = 'Living link between bhakti, manuscript art, and mask theatre; defines Assamese classical identity.',
  practice_and_pedagogy = 'Strict guru–shishya in satra; foot slides (sliding stance), controlled torso, and hasta distinct from Bharatanatyam mudras.',
  performance_context = 'Satra prayer halls, Guwahati Srimanta Sankaradeva Kalakshetra, national classical festivals.',
  notable_exponents = 'Maniram Dutta Muktiyar Barbayan lineage; Jatin Goswami; Mallika Kandali.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-AS' AND i.item_name = 'Sattriya';

UPDATE public.cultural_state_items i SET
  short_description = 'Bidesia: Bhojpuri sung theatre where dance punctuates social satire, caste critique, and romance—male cross-dressed heroines historically common.',
  about_state_tradition = 'Bhojpuri belt touring parties (mandalis) use harmonium, dholak, and nagara; movement draws from launda naach vigour and lok nritya steps.',
  history = 'Aanganbadi and Agra–Patna trade routes spread the form; Bhikhari Thakur''s plays reframed Dalit voices; television and cinema transformed aesthetics.',
  cultural_significance = 'Archives working-class Hindi heartland humour and pathos; UNESCO ICH nomination files sometimes reference related Bhojpuri performance.',
  practice_and_pedagogy = 'Apprenticeship in mandali; improvisation in bol and thumri-like song; contemporary NGOs document elder artists.',
  performance_context = 'Patna Kalidas Rangalaya, village melas, diaspora Mauritius and Trinidad echoes.',
  notable_exponents = 'Bhikhari Thakur legacy troupes; Ramayan Prasad Pandey lineages.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-BR' AND i.item_name = 'Bidesia Dance-Theatre Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Panthi: Satnami community devotional dance—low squat steps, shoulder isolations, and large circles honouring Guru Ghasidas''s egalitarian teaching.',
  about_state_tradition = 'Performed on Maghi Purnima and anniversaries in Raipur, Durg, and rural belts; singers carry jharni while dancers wear saffron or white dhotis and phool mala.',
  history = 'Eighteenth-century anti-caste movement context; post-independence state festivals packaged Panthi for national folk showcases.',
  cultural_significance = 'Embodies Chhattisgarh''s syncretic bhakti and Adivasi–peasant solidarity iconography.',
  practice_and_pedagogy = 'Repetitive knee endurance training; call-response Gauri–Gaura songs; dhol and mandar percussion maps.',
  performance_context = 'Republic Day tableaux, Chhattisgarh foundation day, Lokotsav Bhopal.',
  notable_exponents = 'Satnami samaj cultural committees; national award Panthi troupes.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-CT' AND i.item_name = 'Panthi Dance Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Dekhni: slow Konkani women''s song-dance in swaying lines with oil-lamp or urn balance; often paired in showcase with Mando''s melancholic Luso-Konkani courtly song.',
  about_state_tradition = 'Dekhni lyrics reference river crossing (Godavari) and bride metaphors; Mando uses violin, ghumot, and guitar. Both appear in Kala Academy programmes.',
  history = 'Colonial Goan elite salons; post-1961 Indian state promotion of Goan identity package dances for tourism.',
  cultural_significance = 'Hindu–Catholic shared stage despite differing ritual homes; Hindi cinema popularized Dekhni nationally.',
  practice_and_pedagogy = 'Fine arts schools teach choreographed variants; original community slower tempo and hip-led sway.',
  performance_context = 'Carnival floats, IFFI sidelines, diaspora Goa Day.',
  notable_exponents = 'Kala Academy folk wing; Cota choruses.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-GA' AND i.item_name = 'Dekhni-Mando Dance Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Garba and Raas: Gujarati circular dance around garbha (lamp) or goddess image; dandiya raas uses paired sticks in intricate interlocking rhythms.',
  about_state_tradition = 'Navratri nine-night public and residential societies scale to stadiums; choreography teams win competitions in Ahmedabad and Vadodara. Music shifts from traditional hinch to Bollywood remixes.',
  history = 'Krishna–gopi raas lore; medieval bhakti; modern microphone and EDM hybridization.',
  cultural_significance = 'Defines Gujarati seasonal time worldwide; gender-mixed public night dance with modesty–mobility debates.',
  practice_and_pedagogy = 'Step dictionaries (bebop, dodhiyu), stick pattern drills, costume colour coding by night.',
  performance_context = 'United Way Baroda, GMDC ground Ahmedabad, NJ Navratri halls.',
  notable_exponents = 'Falguni Pathak stage shows; traditional mandal singers.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-GJ' AND i.item_name = 'Garba-Raas Stage Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Jhumar: Haryanvi men''s (and mixed) circle dance with slow sway, clap cycles, and songs of love, harvest, and bravado—named from jhumar (tassel) ornament.',
  about_state_tradition = 'Regions vary: Mewat lyrical vs Bagar vigorous; dhol, sarangi, harmonium ensemble. Stage troupes tighten formations for Surajkund.',
  history = 'Agricultural seasonal leisure; Indian Army regimental Jhumar troupes; reality TV folk fusion.',
  cultural_significance = 'Jat and broader Haryanvi masculine performativity with increasing women''s team entries.',
  practice_and_pedagogy = 'Rhythmic clap on offbeat; dupatta or turban gesture vocabulary; stamina for outdoor dust heat.',
  performance_context = 'Surajkund Mela, Republic Day, university youth festivals.',
  notable_exponents = 'Haryana Kala Parishad; North Zone Cultural Centre troupes.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-HR' AND i.item_name = 'Jhumar Stage Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Nati: Himachali group circle dance with handkerchief waving, stepping patterns, and narsingha (curved horn) drone—distinct Kullu vs Sirmaur substyles.',
  about_state_tradition = 'Dussehra Kullu Mahotsav features massive participatory Nati Guinness attempts; costumes include chola, dhatu, and colourful topi.',
  history = 'Mountain village fairs; colonial ethnography; state tourism branding around the slow-step circle meme.',
  cultural_significance = 'Community cohesion across castes in festive space; alcohol-free public dance option in some villages.',
  practice_and_pedagogy = 'Circle entry protocols; horn and drum synchrony; school competitions standardize 8-count phrases.',
  performance_context = 'Shimla summer festival, Mandi Shivratri, Rohtang cultural shows.',
  notable_exponents = 'HP Department of Language & Culture troupes; village mahila nati teams.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-HP' AND i.item_name = 'Nati Classical Stage Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Paika: Jharkhand–Odisha border martial dance with sword, shield, and acrobatic jumps—drums (dhol, nagara) cue attack–parry mimetic phrases.',
  about_state_tradition = 'Performed at Karma festival and weddings in Kharsawan and Seraikela vicinity; dancers wear colourful dhoti, turban, and ankle bells.',
  history = 'Linked to paik foot-soldier traditions; Chhau mask theatre shares regional percussion DNA.',
  cultural_significance = 'Tribal–peasant martial memory staged as heritage after disarmament eras.',
  practice_and_pedagogy = 'Akharas drill stance; mock combat duets; cardio conditioning for leaping.',
  performance_context = 'State tribal festivals, Republic Day Jharkhand tableau, Seraikella Chhau vicinity melas.',
  notable_exponents = 'Local paika akhara gurus; national scholarship holders.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-JH' AND i.item_name = 'Paika Martial Dance';

UPDATE public.cultural_state_items i SET
  short_description = 'Yakshagana: all-night coastal Karnataka dance-theatre—bhagavata singer-narrators, himmela musicians, and costumed actors in knee-length skirt, towering headgear, and face paint.',
  about_state_tradition = 'Badagutittu (north Kannada) vs Tenkutittu (south) styles; themes from Ramayana, Mahabharata, and local legends. Tala follows chande drum patterns.',
  history = 'Temple veedhi and mela sponsorship; 19th-century printing of prasangas; contemporary women in stree vesha debates.',
  cultural_significance = 'Living Sanskrit–Kannada bilingual stage; influences Kannada cinema visual rhetoric.',
  practice_and_pedagogy = 'Guru-shishya in mela; rigorous leg work in half-squat; eye expression training; vocal doubling for some actors.',
  performance_context = 'Coastal village melas, Rangayana Mysuru collaborations, US tour troupes.',
  notable_exponents = 'Keremane Shambhu Hegde; Chittani Ramachandra Hegde legacy; Guru Bannada Majalu.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-KA' AND i.item_name = 'Yakshagana Nritya-Abhinaya';

UPDATE public.cultural_state_items i SET
  short_description = 'Mohiniyattam: Kerala''s lasya tradition—horizontal torso flow, circular swings, and gliding steps in white-and-gold kasavu costume with simple jewellery.',
  about_state_tradition = 'Reconstructed in Kalamandalam under Vallathol and Kalyani Kutty Amma; Carnatic vocal and edakka percussion support. Repertoire: cholkettu, jatiswaram, varnam, padam, tillana.',
  history = 'Devadasi abolition context; mid-twentieth century codification; distinct from Bharatanatyam mudra set.',
  cultural_significance = 'Feminine divine archetype (Mohini) as aesthetic ideal; Malayalam padams central.',
  practice_and_pedagogy = 'Adavus in three speeds; eye–neck coordination; minimal upper-arm extension vs Tamil styles.',
  performance_context = 'Nishagandhi festival, Onam programmes, global Kerala diaspora sabhas.',
  notable_exponents = 'Kalamandalam Kalyanikutty Amma; Bharati Shivaji; Sunanda Nair.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-KL' AND i.item_name = 'Mohiniyattam';

UPDATE public.cultural_state_items i SET
  short_description = 'Rai: Bundelkhand dance of women carrying large metal mandal (plate) with lit lamp—syncopated hip and knee while singing khyal-style Rai songs.',
  about_state_tradition = 'Strong in Datia, Tikamgarh, Chhatarpur; male dholak and harmonium support. Songs range from Krishna leela to seasonal work lyrics.',
  history = 'Court and village women''s night gatherings; MP State awards recognize Rai exponents; fusion with stage lighting in Ustad Alauddin Khan Sangeet evam Nritya Akademi shows.',
  cultural_significance = 'Women''s expressive public space in patriarchal belt; plate-lamp as offering metaphor.',
  practice_and_pedagogy = 'Balance training with water-filled plates before fire; chorus entry timing; ankle bell layering.',
  performance_context = 'Khajuraho dance festival sidelines, Lokrang Bhopal, village Navratri.',
  notable_exponents = 'National award Rai artists from Bundelkhand districts.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-MP' AND i.item_name = 'Rai Dance Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Lavani: high-tempo Marathi song-dance from tamasha tent theatre—powerful pad ghungroo, sharp chakkars, and socially pointed lavani sahitya.',
  about_state_tradition = 'Kolhapur and Pune gharanas differ in tempo and abhinaya; dholki, tuntuna, and halgi drive rhythm. Costumes: nauvari saree, back-comb, heavy jewellery.',
  history = 'Peshwa and British-era entertainment; women performers'' labour rights debates; film Sangeet Lavani crossover.',
  cultural_significance = 'Feminine voice on desire, politics, and satire; caste and gender politics in who performs on elite stages.',
  practice_and_pedagogy = 'Foot stamping (thap), rapid chhandas, coquettish mugda abhinaya; voice projection without mic training.',
  performance_context = 'Pune Ganesh festival, Marathi rangabhoomi, Zee Gaurav–style TV revivals.',
  notable_exponents = 'Vithabai Narayangaonkar; Surekha Punekar; hereditary tamasha and contemporary stage artists.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-MH' AND i.item_name = 'Lavani Stage Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Manipuri Ras: Vaishnav classical dance of Manipur—circular ras mandali, pung (barrel drum) cholom, and delicate kneeling spins in jewel-toned potloi costume.',
  about_state_tradition = 'Maharas, Nitya Ras, and Vasanta Ras items; Gita Govinda and Bengali padavali lyrics. Live singing (ishei) often accompanies.',
  history = 'Meitei kingship and Bengali Bhagavata influence; Guru Bipin Singh and Kalakshetra collaboration spread pedagogy outside Manipur.',
  cultural_significance = 'Sangeet Natak Akademi classical; embargo-era cultural resilience symbol; women''s dominant stage presence.',
  practice_and_pedagogy = 'No ankle bells; emphasis on supple spine and inward energy; pung dance as separate male virtuosity track.',
  performance_context = 'Jawaharlal Nehru Manipur Dance Academy, Imphal festivals, global interfaith showcases.',
  notable_exponents = 'Guru Bipin Singh; Darshana Jhaveri; Rajkumar Singhajit Singh.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-MN' AND i.item_name = 'Manipuri Ras';

UPDATE public.cultural_state_items i SET
  short_description = 'Nongkrem: Khasi thanksgiving dance at Smit—young women in costly silk dhotis step lightly on earth while men stand with swords and white fly-whisks, accompanied by tangmuri pipes and drums.',
  about_state_tradition = 'Ka Pemblang Nongkrem honours Syiem (chief) and Ka Blei Synshar (goddess of harvest). Female line balances ritual urn or plate; movement minimal, dignified.',
  history = 'Pre-Christian ritual core persists inside Christian-majority society; tourism schedules compress multi-day rites.',
  cultural_significance = 'Matrilineal prestige display; earth-touching respect motif.',
  practice_and_pedagogy = 'Village maidens selected by clan; months of jewellery borrowing; male stance training for sword salute.',
  performance_context = 'Smit Nongkrem annually; Hornbill Festival staged excerpt; Shillong autumn.',
  notable_exponents = 'Syiem of Khyrim office ritual dancers; Khasi Students Union cultural wing.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-ML' AND i.item_name = 'Nongkrem Dance Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Cheraw: Mizo bamboo dance—dancers hop between horizontally clapped green bamboos while puanchei shawls swirl; requires split-second timing.',
  about_state_tradition = 'Taught in schools as state heritage; competition teams use uniform Mizo textiles; clappers kneel at bamboo ends.',
  history = 'Agricultural rite origins disputed; post-statehood cultural policy elevated Cheraw as emblem.',
  cultural_significance = 'Youth teamwork metaphor; international folk festival staple for Mizoram.',
  practice_and_pedagogy = 'Slow metronome training to full speed; ankle injury prevention drills; gender-mixed squads.',
  performance_context = 'Chapchar Kut, Chapchar Kut spring festival, Republic Day Delhi.',
  notable_exponents = 'MZU cultural teams; Aizawl district winners.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-MZ' AND i.item_name = 'Cheraw Dance';

UPDATE public.cultural_state_items i SET
  short_description = 'Chang Lo: Chang Naga victory and feast dance—men in warrior regalia with dao, shields, and headhunter-era iconography (now symbolic), women in ornamental shawls.',
  about_state_tradition = 'Performed at Konyak and Chang morungs historically; post-ceasefire staged for Hornbill Festival with choreographed battle narratives.',
  history = 'Headhunting cessation transformed dance into heritage spectacle; audio archives at Kohima seminary.',
  cultural_significance = 'Tribe-specific identity within Naga umbrella; costume semiotics of feathers and cowries.',
  practice_and_pedagogy = 'Drill-like line entries; call-response warrior shouts; museum consultation for respectful staging.',
  performance_context = 'Hornbill Festival Kisama, statehood day, NEZCC tours.',
  notable_exponents = 'Tribal cultural troupes from Tuensang and Mokokchung regions.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-NL' AND i.item_name = 'Chang Lo Dance Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Odissi: sculptural tribhangi stance, chauka footwork, and torso isolation—reconstructed from Mahari temple practice and Gotipua boy acrobatic tradition.',
  about_state_tradition = 'Odisha holds Konark and temple relief as movement textbook; repertoire: mangalacharan, batu, pallavi, abhinaya, moksha. Mardala drum and Pakhawaj-style phrasing.',
  history = '1950s–60s Jayantika collaboration; Kelucharan Mohapatra choreographic codification; UNESCO and global gurus.',
  cultural_significance = 'State cultural flagship; Odia language sahitya in abhinaya; feminist reappraisals of devadasi history.',
  practice_and_pedagogy = 'Guru-shishya parampara; strength for chowka holds; Sanchari bhava training; live music literacy.',
  performance_context = 'Konark festival, Mukteswar dance festival, US/Europe winter seasons.',
  notable_exponents = 'Kelucharan Mohapatra; Sanjukta Panigrahi; Sonal Mansingh; Sujata Mohapatra.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-OR' AND i.item_name = 'Odissi';

UPDATE public.cultural_state_items i SET
  short_description = 'Giddha: Punjabi women''s circle dance of boliyan (witty couplets), clap games, and dupatta gestures—mocking in-laws and celebrating kinship.',
  about_state_tradition = 'Performed at teeyan, weddings, and Vaisakhi; dholki and hand claps mark time. Stage Giddha tightens formations for competitions.',
  history = 'Agrarian women''s oral tradition; diaspora university teams (Canada, UK) innovate formations.',
  cultural_significance = 'Feminist reading of public female voice; contrast with male Bhangra spotlight.',
  practice_and_pedagogy = 'Bol improvisation literacy; ring games (giddha with chairs); costume colour coordination.',
  performance_context = 'PU Chandigarh youth fests, Toronto Vaisakhi parade, Jalandhar radio recordings.',
  notable_exponents = 'Punjab Arts Council troupes; international champion university teams.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-PB' AND i.item_name = 'Giddha Stage Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Ghoomar: Rajasthani women''s spinning dance in circular veil work—heavy ghagra, choli, and odhni hiding and revealing face in rhythm.',
  about_state_tradition = 'Rajput, Gujjar, and tribal variants differ; songs celebrate Holi, Teej, and marriage. Sanjay Leela Bhansali film amplified global recognition—and controversy over community ownership.',
  history = 'Courtly zenana depictions in miniature; modern tourism hotel dinners standardize 6/8 spin.',
  cultural_significance = 'Bridal modesty choreography; regional pride; debates on who may perform for camera.',
  practice_and_pedagogy = 'Spotting technique for dizziness management; hand on hip vs interlocked fingers styles; group inward–outward spiral.',
  performance_context = 'Jaipur literature festival cultural nights, Desert Festival Jaisalmer, wedding sangeet.',
  notable_exponents = 'Rajasthan state cultural troupes; community mahila mandals.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-RJ' AND i.item_name = 'Ghoomar Stage Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Singye Khang/Chham (listed as Singhi Chham): Sikkimese Buddhist masked dance—snow-lion (singhi) costumed pairs and wrathful deities in monastery courtyards.',
  about_state_tradition = 'Rumtek, Pemayangtse, and Enchey host annual cham; cymbals, long horns, and ritual daggers accompany. Lion dance honours Padmasambhava lore.',
  history = 'Nyingma and Kagyu liturgical calendars; Chinese New Year lion parallels only superficial.',
  cultural_significance = 'State identity alongside Lepcha and Bhutia textiles in costume.',
  practice_and_pedagogy = 'Monks train for years before heavy mask roles; jumping in lion suit requires core strength.',
  performance_context = 'Losar, Pang Lhabsol, Gangtok tourism schedules.',
  notable_exponents = 'Rumtek and Pemayangtse cham leaders.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-SK' AND i.item_name = 'Singhi Chham';

UPDATE public.cultural_state_items i SET
  short_description = 'Bharatanatyam: Tamil-born dance with adavu lexicon, araimandi posture, and margam repertoire—alarippu to tillana—rooted in sadir and Tanjore Quartet systematization.',
  about_state_tradition = 'Chennai December season (Marghazi) is global hub; music: mridangam, violin, nattuvangam, sometimes flute. Themes: Shiva, Vishnu, Tamil padams, and contemporary choreography.',
  history = 'Devadasi abolition and Rukmini Devi Arundale''s Kalakshetra reform-era debate; Balasaraswati counter-lineage; feminist and Dalit re-readings today.',
  cultural_significance = 'Most internationally visible Indian classical dance; syllabus in CBSE and foreign universities.',
  practice_and_pedagogy = 'Daily adavu counts; abhinaya from Natya Shastra and regional manuals; nattuvanar conducting; arangetram milestone.',
  performance_context = 'Music Academy, Narada Gana Sabha, international festivals, Instagram arangetram streams.',
  notable_exponents = 'Tanjore Quartet legacy; Balasaraswati; Yamini Krishnamurthy; Alarmel Valli; Malavika Sarukkai.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-TN' AND i.item_name = 'Bharatanatyam';

UPDATE public.cultural_state_items i SET
  short_description = 'Perini Shivatandavam: revived Kakatiya-era warrior dance—explosive jumps, prerana (warm-up) shouts, and nandi tandava imagery in male ensemble.',
  about_state_tradition = 'Nataraja Ramakrishna reconstructed from sculpture and text; performed at forts (Warangal) and state events in red dhoti, rudraksha, and percussion-heavy score.',
  history = '1980s Telangana cultural revival; post-bifurcation state symbol; martial fitness camps for youth.',
  cultural_significance = 'Shaiva Telugu identity; counterweight to Andhra-side Kuchipudi emphasis in discourse.',
  practice_and_pedagogy = 'Military-style conditioning; group unison leaping; drumming syllables (yati).',
  performance_context = 'Warangal arts fests, Republic Day, Telugu cinema title sequences.',
  notable_exponents = 'Dr. Nataraja Ramakrishna students; University of Hyderabad performance studies documentations.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-TS' AND i.item_name = 'Perini Shivatandavam';

UPDATE public.cultural_state_items i SET
  short_description = 'Hojagiri: Reang women''s balancing dance—earthen pitchers, oil lamps, and sometimes bottle on head while bending backward in line; male dhol and chongpreng (string instrument) accompany.',
  about_state_tradition = 'Lakshi Puja post-harvest; young girls train on increasing stack height. Costume: risa upper cloth, phanek lower, coin jewellery.',
  history = 'Tripura tribal autonomy movements highlighted Hojagiri in state icons; BRU resettlement communities continue practice.',
  cultural_significance = 'Matrilineal Reang aesthetic; agility as devotional offering.',
  practice_and_pedagogy = 'Core strength and neck control from childhood; spotters during training; insurance concerns on commercial stages.',
  performance_context = 'Agartala Lokotsav, NE festivals, national folk dance competitions.',
  notable_exponents = 'Reang cultural troupes; national award holders from Dhalai district.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-TR' AND i.item_name = 'Hojagiri Dance Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Kathak: North Indian classical dance—intricate tatkar (footwork), chakkars (spins), thumri-dadra abhinaya, and virtuosic tukras from tabla–dancer dialogue.',
  about_state_tradition = 'Lucknow (courtly grace, nazakat), Jaipur (technical purity, fast footwork), and Banaras gharanas dominate UP landscape; sarangi or harmonium melody, padhant recitation.',
  history = 'Tawaif and court cultures; post-1857 urban migration; Proscenium era gurus (Shambhu Maharaj, Birju Maharaj); contemporary Kathak contemporary fusions.',
  cultural_significance = 'Hindi–Urdu poetry in dance; global touring staple; gender politics of courtesan lineage reclamation.',
  practice_and_pedagogy = 'Ankle bell (ghungroo) graduation by weight; layakari (playing with tempo); guru-shishya and Kathak Kendra degrees.',
  performance_context = 'Kathak Kendra Delhi, Lucknow Mahotsav, ICCR tours, Sadler''s Wells and European ensemble collaborations.',
  notable_exponents = 'Birju Maharaj; Sitara Devi; Kumudini Lakhia; Rajendra Gangani.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-UP' AND i.item_name = 'Kathak';

UPDATE public.cultural_state_items i SET
  short_description = 'Chholiya: Kumaoni–Garhwali sword dance in wedding processions—men in white with turbans brandish khukri-like swords and shields to rhythmic drum and ransingha.',
  about_state_tradition = 'Guards symbolic evil spirits at baraat; aggressive footwork and mock combat pairs. Almora and Pithoragarh styles vary slightly.',
  history = 'Linked to medieval border warfare folklore; UNESCO ICH files sometimes cluster with Garhwal Kumaon seasonal rituals.',
  cultural_significance = 'Mountain Hindu masculinity display; tourism wedding packages hire troupes.',
  practice_and_pedagogy = 'Sword safety training; drunk-procession risk management in modern weddings; brass band fusion.',
  performance_context = 'Village weddings, Nanda Devi rajjat yatra vicinity, state day Dehradun.',
  notable_exponents = 'Kumaon Regiment cultural teams; local baraat bands.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-UK' AND i.item_name = 'Chholiya Dance Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Gaudiya Nritya: reconstructed Bengali classical style drawing Vaishnav padavali, Braja manipuri cross-currents, and tala from Kathak/Odissi contact—tagore-era and post-2000 codification.',
  about_state_tradition = 'Rabindra Bharati and independent gurus built syllabi; white sari, red border, and tribhanga poses echo sculpture. Repertoire includes stuti, nritya, and abhinaya to Bengali songs.',
  history = 'W.B. State Music Academy recognition; debates on revival methodology vs manuscript recovery parallel Odissi revival arguments.',
  cultural_significance = 'Bengal''s institutional answer to Bharatanatyam/Kathak hegemony in eastern sabhas.',
  practice_and_pedagogy = 'Guru Shashi Mahato, Mahua Mukherjee lineages; cross-training in martial kathi stance sometimes cited.',
  performance_context = 'Kolkata Dover Lane cultural weeks, EZCC, Bangladesh cross-border festivals.',
  notable_exponents = 'Mahua Mukherjee; Amitabh Bhattacharya; young gurus in Salt Lake academies.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-WB' AND i.item_name = 'Gaudiya Nritya';

UPDATE public.cultural_state_items i SET
  short_description = 'Nicobari community dance: ensemble line dances at Ossuary Feast (Kamaut) and weddings—coconut-shell leg rattles, call-response song, and swaying arms in coconut-leaf skirts.',
  about_state_tradition = 'Car Nicobar, Kamorta, and other islands vary costume; post-tsunami resettlement affected practice continuity; anthropological film archives at ANET.',
  history = 'Restricted island access preserves some isolation; Christian hymnody sometimes interpolates melodies.',
  cultural_significance = 'Nicobarese identity marker separate from Andamanese groups.',
  practice_and_pedagogy = 'Youth learn at community hall; tourism performances regulated for respect.',
  performance_context = 'Island administration days, Car Nicobar cultural programmes, Port Blair curated shows.',
  notable_exponents = 'Tribal council–organized youth groups.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-AN' AND i.item_name = 'Nicobari Community Dance';

UPDATE public.cultural_state_items i SET
  short_description = 'Bhangra: Panjabi harvest victory dance—high leaping, luddi sideways shuffle, and dhol-driven phumman (bellows) energy; competitive teams use strict eight-count modules.',
  about_state_tradition = 'PU Chandigarh and GNDU host inter-college battles; costumes: chadr, pag, vardiyaan. Live dhol or electronic tracks.',
  history = 'Male labour celebration from Baisakhi; 1970s UK diaspora globalized stage Bhangra music genre.',
  cultural_significance = 'Sikh and Punjabi secular pride icon; gender inclusion of women''s teams grows.',
  practice_and_pedagogy = 'Cardio and plyometrics; stick (saunchi) routines; formations for judges'' sightlines.',
  performance_context = 'World Bhangra Cup Canada, Delhi Horn OK Please, Bollywood films.',
  notable_exponents = 'Giddha–Bhangra academies in Mohali; UK DCS and Heera era musicians.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-CH' AND i.item_name = 'Bhangra Stage Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Vira (coastal UT folk): Daman–Diu Indo-Portuguese circle dances at feast days—brass band, polka-influenced steps, and Konkani lyric refrains.',
  about_state_tradition = 'Staged at Christmas, Carnival, and Our Lady of Fatima processions; dancers wear straw hats and ribbons; less documented than Goa Mando but structurally related.',
  history = 'Portuguese colonial fort towns; post-1961 Indian integration merged administration with Gujarat tourism circuits.',
  cultural_significance = 'Minority Catholic coastal identity within UT pluralism.',
  practice_and_pedagogy = 'Parish youth clubs rehearse; elders correct circle direction (clockwise omen).',
  performance_context = 'Diu Festival, church forecourts, Silvassa proximity melas.',
  notable_exponents = 'Parish cultural committees; UT art & culture department.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-DN' AND i.item_name = 'Vira Dance Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Delhi Kathak rangmanch: national capital''s festival ecosystem—Kathak Kendra, Kamani Auditorium, IHC, and Oddisi/Kuchipudi guest seasons with lighting design and tarana orchestration.',
  about_state_tradition = 'Institutions host monthly baithaks; critics'' circles (Sruti, Narthaki) headquartered here; diplomacy uses ICCR Kamani shows.',
  history = 'Delhi became post-Partition magnet for Awadh and Rajasthan gharana gurus; TV Doordarshan classical hours filmed here.',
  cultural_significance = 'Sets national taste-making; access vs elite pricing debates.',
  practice_and_pedagogy = 'Kathak Kendra diploma; NSD cross-pollination; stagecraft modules (makeup, wings).',
  performance_context = 'Dance India, ICCR Horizon series, Spic Macay youth lec-dems.',
  notable_exponents = 'Birju Maharaj Delhi ghar; Saswati Sen; Aditi Mangaldas.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-DL' AND i.item_name = 'Kathak Rangmanch Circuit';

UPDATE public.cultural_state_items i SET
  short_description = 'Rouf: Kashmiri women''s spring dance in linked lines—front–back stepping to Rouf songs about nature, love, and separation, often in zoon dub (moon window) architecture.',
  about_state_tradition = 'Performed after sowing season; no instruments in pure form—clapping and voice; colourful phiran, kasaba, and taranga.',
  history = 'Sufi and Persian poetic metres influenced lyrics; conflict decades reduced public night performance; revival in university fests.',
  cultural_significance = 'Gendered safe public joy; Bollywood “Bumbro” popularized tune globally.',
  practice_and_pedagogy = 'Synchronized line without leader drift; modest gaze choreography; indoor vs outdoor spacing.',
  performance_context = 'Tulip festival sidelines, Kashmir University, Jammu winter fests.',
  notable_exponents = 'Kashmir cultural academy women troupes; Doordarshan Srinagar archives.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-JK' AND i.item_name = 'Rouf Dance Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Cham: Ladakhi monastic masked dance-drama—wrathful deities conquer demons; slow processional entries accelerate into acrobatic black-hat dancers.',
  about_state_tradition = 'Hemis, Thiksey, Lamayuru hold major tsechus; monks train in retreat; lay musicians sometimes supplement dungchen horns.',
  history = 'Tibetan Buddhist continuity; tourism now funds longer festivals; photography ethics debated.',
  cultural_significance = 'Merit-making public teaching; Ladakh UT branding.',
  practice_and_pedagogy = 'Years before wearing heavy masks; meditation prerequisite in some monasteries; secret choreography segments.',
  performance_context = 'Hemis Festival July; Sindhu Darshan cultural nights; documentary films.',
  notable_exponents = 'Hemis and Matho oracle monastery dancers.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-LA' AND i.item_name = 'Cham Dance';

UPDATE public.cultural_state_items i SET
  short_description = 'Lava: Lakshadweep group dance—men in white lungi and vest, women in kachi, move in circles to island Malayalam songs with thavil-like drum and coconut shell beats.',
  about_state_tradition = 'Performed at weddings and Eid; hip-led sway and hand claps; influenced by Malabar coast contact.',
  history = 'UT administration promotes at Republic Day; limited documentation vs Andaman groups.',
  cultural_significance = 'Sunni Muslim island culture expression; boat metaphor lyrics.',
  practice_and_pedagogy = 'School cultural competitions; audio recordings for diaspora Kavaratti families.',
  performance_context = 'Island Independence Day, Kochi ship connections tourism.',
  notable_exponents = 'UT schools'' cultural squads.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-LD' AND i.item_name = 'Lava Dance Tradition';

UPDATE public.cultural_state_items i SET
  short_description = 'Bharatanatyam (Puducherry bani): Tamil classical dance taught in Pondy''s Franco-Tamil institutions—often Kalakshetra-influenced margam with local sabha culture tied to Manakula Vinayagar and Aurobindo ashram arts.',
  about_state_tradition = 'Teachers commute from Chennai season; French Quarter venues host intimate arangetrams; experimental crossovers with Western classical at Auroville.',
  history = 'Colonial Tamil theatre (Subramania Bharati visits) and post-merger Indian state arts funding.',
  cultural_significance = 'Bilingual audience development; smaller but dedicated December parallel circuit.',
  practice_and_pedagogy = 'Same adavu foundation as Tamil Nadu; emphasis on French-language program notes in some festivals.',
  performance_context = 'Puducherry Heritage Festival, Bharathi Museum events, Auroville amphitheatre.',
  notable_exponents = 'Local Bharatanatyam academies along Beach Road; Kalakshetra alumni residents.',
  updated_at = now()
FROM public.cultural_state_hubs h
WHERE i.hub_id = h.id AND h.category = 'classical_dance' AND h.state_code = 'IN-PY' AND i.item_name = 'Bharatanatyam (Puducherry Bani)';
