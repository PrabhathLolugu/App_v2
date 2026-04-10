-- Expand hindu_festivals narrative fields with richer detail.
-- Does NOT touch image_url, id, slug, name, or order_index.

UPDATE public.hindu_festivals SET
  short_description = 'Deepavali: rows of lamps, Lakshmi puja, and the homecoming of Rama—India''s great festival of light, prosperity, and moral victory.',
  description = 'Diwali (Deepavali, “row of lamps”) is among the most widely observed Hindu festivals. Families clean and decorate homes, draw rangoli at doorways, light clay diyas and electric lamps, and gather for Lakshmi puja to invite auspiciousness and gratitude for abundance. The festival weaves together multiple sacred narratives: in North India it is strongly associated with Lord Rama''s return to Ayodhya after defeating Ravana, when citizens lit lamps to welcome the rightful king; in other traditions it honours Krishna''s victory over Narakasura or the emergence of Lakshmi during the churning of the ocean. Economically and socially, Diwali marks a peak season for gifting, new account books in some communities, and reunion of dispersed families. The tone is both joyful and reflective—celebrating outer light while encouraging inner clarity and ethical living (dharma).',
  when_celebrated = 'Kartik Amavasya (new moon of Kartik month, lunisolar Hindu calendar).',
  when_details = 'Falls between mid-October and mid-November in the Gregorian calendar; exact date shifts each year because it follows the lunar cycle. In many regions the main Lakshmi puja is on Amavasya night; in some areas celebrations begin on Dhanteras two days earlier and extend through Bhai Dooj. Diaspora communities often cluster observances on the nearest weekend for work and school schedules while keeping the traditional tithi for puja when possible.',
  where_celebrated = 'Observed across India with regional emphases: North and West India emphasize Rama''s return and Lakshmi worship; parts of South India foreground Krishna and Narakasura legends. Nepal, Sri Lanka, Fiji, Mauritius, Singapore, Malaysia, the United Kingdom, the United States, Canada, and the Middle East host large public and domestic celebrations. Major temple towns (Ayodhya, Varanasi, Madurai) and commercial hubs alike see peak pilgrimage and decoration.',
  how_celebrated = 'Typical practices include thorough house cleaning, new clothes, rangoli, lighting diyas at dusk, Lakshmi and Ganesha puja, distribution of mithai (sweets), and visiting neighbours and elders. Fireworks remain common in some places though many families now prefer lamps and community laser shows for safety and air quality. Traders may close old ledgers and worship new ones; children receive gifts; community halls host cultural programmes. Jains commemorate Mahavira''s nirvana on the same period in many calendars; Sikhs observe Bandi Chhor Divas at the same seasonal window—so public events in plural societies may be interfaith.',
  history = 'The festival layer synthesizes ancient agrarian and lamp-offering customs with epic and Puranic stories. The Ramayana tradition of Ayodhya illuminated for Rama is medieval and early modern in its pan-Indian popular form; the association with Lakshmi and the mercantile New Year grew alongside trade networks. Colonial and post-colonial migration spread Deepavali globally, where it has become a visible symbol of Indian heritage.',
  significance = 'Diwali encodes the victory of light over darkness, knowledge over ignorance, and dharma over adharma. It is a time for forgiveness, charity (especially to those in need), and strengthening family bonds. For many, it is the year''s most important occasion to express gratitude to the divine and to renew personal and communal ethical commitments.',
  scriptures_related = 'Valmiki Ramayana (Rama''s return); Ramcharitmanas; Bhagavata Purana (Krishna, Narakasura); Vishnu Purana; Padma Purana (Lakshmi); Mahabharata (Rajasuya and churning narratives echo prosperity themes).',
  updated_at = now()
WHERE slug = 'diwali';

UPDATE public.hindu_festivals SET
  short_description = 'Holi: spring colours, communal joy, and the triumph of Prahlad''s devotion—celebrating renewal and the playful love of Radha-Krishna.',
  description = 'Holi is a exuberant spring festival famous for coloured powders (gulal) and water play. Its religious core is the story of Prahlad, the boy devotee of Vishnu, whom his father Hiranyakashipu tried to kill; his aunt Holika, who had a boon against fire, perished in the flames while Prahlad was saved—commemorated on Holika Dahan the night before Holi. In Braj and Vrindavan, Holi also celebrates the divine love of Radha and Krishna: Krishna''s blue complexion and Radha''s fair skin become a metaphor for unity through play (lila). Socially, Holi temporarily dissolves strict hierarchies: people of many backgrounds mingle in streets, temples, and campuses; the festival is a powerful expression of seasonal joy after winter.',
  when_celebrated = 'Phalguna Purnima (full moon of Phalguna).',
  when_details = 'Usually March in the Gregorian calendar. Holika Dahan occurs on Phalguna Purnima evening (or the prior night depending on local calculation); main colour play is on the following day (Rangwali Holi). In Braj, Lathmar Holi and other local variants may fall on different adjacent days.',
  where_celebrated = 'North India leads in public colour play; strong celebrations in Uttar Pradesh (Mathura, Vrindavan, Barsana), Rajasthan, Bihar, West Bengal (Basanta Utsav at Shantiniketan), Maharashtra, and Gujarat. Nepal observes Holi; the Caribbean (Phagwah), United Kingdom, United States, and Gulf cities host large diaspora events. Temples and university Indian student associations often organize controlled, inclusive gatherings.',
  how_celebrated = 'Evening before: bonfire (Holika Dahan) with circumambulation and prayers. Day: applying gulal and abeer, spraying water, singing Holi songs (faag), eating gujiya, malpua, and thandai (often without intoxicants in family settings). In some traditions worship of Krishna idols includes colour; in others community drums and processions. Hosts should use skin-safe colours and consent-aware play; many cities now promote eco-friendly organic powders.',
  history = 'The Prahlad narrative appears in Bhagavata Purana and Vishnu Purana. Medieval Bhakti poetry (Surdas, Mirabai) enriched Krishna–Holi imagery. Colonial photography and cinema globalized the visual of Holi as “the festival of colours.”',
  significance = 'Holi teaches that steadfast devotion protects the righteous, that spring and emotional renewal belong to everyone, and that ritual play can build social cohesion. It is also a pastoral festival aligned with the ripening of crops in many regions.',
  scriptures_related = 'Bhagavata Purana (Prahlad, Book 7); Vishnu Purana; Brahmanda Purana; Garga Samhita and Padma Purana (Krishna lila); regional Holi kirtans and folk epics.',
  updated_at = now()
WHERE slug = 'holi';

UPDATE public.hindu_festivals SET
  short_description = 'Nine nights of Devi: fasting, garba and dandiya, Durga Puja pandals—honouring the Goddess in her many victorious forms.',
  description = 'Navratri (“nine nights”) is dedicated to the Divine Mother—Durga, Lakshmi, and Saraswati in sequence in many traditions, or the nine forms of Durga (Navadurga). The autumn Sharad Navratri is the most prominent, culminating in Vijayadashami; Chaitra Navratri in spring is also widely observed. The festival dramatizes the cosmic struggle between the goddess and demonic forces, especially Mahishasura, and by extension the devotee''s inner battle with ego and negativity. Expression ranges from austere home altars with fasting and japa to massive public dance circles and city-wide pandal culture.',
  when_celebrated = 'Sharad (Ashvina) Navratri and Chaitra Navratri (first nine nights of the bright fortnight in those months).',
  when_details = 'Sharad Navratri typically falls late September to October; Chaitra Navratri around March–April. Each of the nine days (and nights) is associated with a specific aspect of the Goddess; ashtami and navami often see peak attendance and kanya puja in some regions.',
  where_celebrated = 'Pan-India with iconic regional styles: Gujarat and Rajasthan for Garba/Dandiya; West Bengal, Assam, and Odisha overlap with Durga Puja; North India for Ram Leela adjacency; South India for Golu (Bommai Kolu) displays and sundal prasad; Nepal and diaspora temples worldwide.',
  how_celebrated = 'Common elements: fasting or restricted diet, daily Devi puja, recitation of Durga Saptashati (Devi Mahatmyam), kumkum and flower offerings, and lamps at night. Gujarat: coordinated Garba and Dandiya in grounds and societies. Tamil Nadu: stepped displays of dolls narrating myth and history. Bengal: sculptural Durga with full public ritual arc. Many communities perform Kanya Puja (honouring young girls as embodiments of Shakti) on ashtami or navami.',
  history = 'The Devi Mahatmyam portion of Markandeya Purana crystallized the theology of Mahishasura mardini. Royal and agrarian patronage linked Navratri to harvest and martial readiness. Modern urban Navratri merged traditional vrata with stadium-scale dance and sound systems.',
  significance = 'Navratri affirms shakti—the active power of the divine—as essential to cosmic order. It is a period for spiritual discipline, cultural performance, and female divine imagery that balances masculine-centric narratives. For many farmers it coincides with post-monsoon gratitude.',
  scriptures_related = 'Markandeya Purana (Devi Mahatmyam / Durga Saptashati); Devi Bhagavata Purana; Kalika Purana; regional Agamas and Tantras for temple protocols.',
  updated_at = now()
WHERE slug = 'navratri';

UPDATE public.hindu_festivals SET
  short_description = 'Bengal''s grand Durga Puja: artistic pandals, dhak and dhunuchi, and the Goddess''s annual visit home before immersion.',
  description = 'Durga Puja in West Bengal and neighbouring regions is both a religious observance and a mass public art festival. The goddess Durga—riding her lion, slaying Mahishasura—is worshipped as Uma visiting her natal home with her children Ganesha, Lakshmi, Kartikeya, and Saraswati. Elaborate temporary structures (pandals) house clay idols crafted by traditional artisans (kumors). Five key days (Shashthi through Dashami) structure ritual, food offerings (bhog), cultural programmes, and immense street participation. The aesthetic competition among neighbourhoods and clubs has turned the festival into a UNESCO-recognized intangible heritage phenomenon in its Kolkata expression.',
  when_celebrated = 'Ashvina month (Devi Paksha), aligned with the last five or six days of Navratri through Vijayadashami.',
  when_details = 'Usually late September to October. Mahalaya (prior to Shashthi) marks the “invitation” of the goddess; Shashthi is Bodhon; Saptami, Ashtami, and Navami are peak days; Dashami is Sindoor Khela and Visarjan (immersion) in many communities.',
  where_celebrated = 'West Bengal is the epicentre; also Assam (similar idiom), Odisha, Bihar, Jharkhand, Tripura, and Bangladesh. Global Bengali diaspora—in London, New York, Houston, Sydney—replicates pandal culture at varying scales.',
  how_celebrated = 'Key practices: visiting pandals (pandal hopping), pushpanjali on Ashtami/Navami, distributing bhog, dhunuchi naach with incense burners before the idol, sindoor play among married women on Dashami, and processions to rivers for visarjan. Homes may host smaller chala chitra or baro yaar versions. New themes each year link mythology to contemporary art and social commentary.',
  history = 'Medieval landlord (zamindar) household pujas expanded into community sarbojanin pujas in colonial Kolkata. Partition and migration spread the format. Artisan economies in Kumartuli (Kolkata) and similar clusters sustain hereditary sculptural skills.',
  significance = 'Durga Puja celebrates feminine divine power, maternal return, and collective joy. It reinforces Bengali language, music, and visual arts, and provides a yearly rhythm for urban solidarity and charitable drives attached to clubs.',
  scriptures_related = 'Devi Mahatmyam (Markandeya Purana); Kalika Purana; Brihan-Nandikeshvara Purana; Bengali paddhatis and smriti manuals for seasonal rites.',
  updated_at = now()
WHERE slug = 'durga-puja';

UPDATE public.hindu_festivals SET
  short_description = 'Ganesh Chaturthi: welcoming the elephant-headed Lord of beginnings—home and public mandaps, modak, and visarjan with song.',
  description = 'Ganesh Chaturthi celebrates Ganesha (Vinayaka), son of Shiva and Parvati, as patron of wisdom, writing, and successful undertakings. Devotees install murtis in homes and, famously in Maharashtra, in neighbourhood sarvajanik mandaps for one and a half to eleven days. Daily puja includes shodashopachara, modak naivedya, and aarti; immersion (visarjan) sends Ganesha back with prayers to return next year. The public scale of the festival in Mumbai and Pune was amplified in the late nineteenth and twentieth centuries as a community-organized cultural assertion, blending devotion with music, theatre, and social service.',
  when_celebrated = 'Bhadrapada Shukla Chaturthi (fourth day of the bright fortnight of Bhadrapada).',
  when_details = 'Typically August–September. Ganesha is worshipped for a chosen odd number of days (1, 3, 5, 7, 11) depending on family or mandap tradition; Anant Chaturdashi is the most common public visarjan day in Maharashtra.',
  where_celebrated = 'Strongest in Maharashtra, Goa, Karnataka, Andhra Pradesh, Telangana, and Tamil Nadu; increasingly pan-Indian in cities. Nepal and diaspora temples host parallel events. Coastal visarjan sites (beaches, rivers) draw millions in processions.',
  how_celebrated = 'Pranapratishtha installs the idol''s life-force; daily abhishekam, red flowers, durva grass, and modak offerings; Ganesha atharvashirsha recitation in many homes; public cultural programmes and competitions. Visarjan processions feature drums, lezim, and eco-conscious clay idols or artificial tanks to reduce water pollution.',
  history = 'Puranic stories narrate Parvati''s creation of Ganesha and his restoration with an elephant head after confrontation with Shiva. Lokmanya Tilak and others promoted public mandaps in colonial India to build civic Hindu solidarity; the form persists as both devotion and neighbourhood identity.',
  significance = 'Ganesha is vighnaharta—remover of obstacles—and invoked first in ritual sequences. The festival teaches renewal, community labour (seva in mandaps), and environmental awareness when choosing idol materials and immersion methods.',
  scriptures_related = 'Ganesha Purana; Mudgala Purana; Shiva Purana; Ganapati Atharvashirsha (Upanishadic hymn); Brahma Vaivarta Purana.',
  updated_at = now()
WHERE slug = 'ganesh-chaturthi';

UPDATE public.hindu_festivals SET
  short_description = 'Makar Sankranti: the sun enters Capricorn—kites, sesame-jaggery, holy dips, and harvest gratitude across India''s many names.',
  description = 'Makar Sankranti marks the sun''s apparent entry into Makara (Capricorn), beginning Uttarayana—the northward journey of the sun associated with longer days and auspiciousness in Hindu astrological tradition. Unlike most Hindu festivals tied solely to the moon, its main observance often falls on a fixed solar date (14 or 15 January). The same astronomical moment is celebrated as Pongal in Tamil Nadu, Magh Bihu in Assam, Lohri/Paush in Punjab, Uttarayan in Gujarat, and by other local names. Foods featuring sesame (til) and jaggery symbolize warmth and shared sweetness; kite flying turns rooftops into social arenas.',
  when_celebrated = 'Solar transition to Makara (Makar Sankranti).',
  when_details = 'Usually 14 January; occasionally 15 January when leap-year adjustments apply. Some traditions split rituals across Sankranti and the following one or two days (e.g., Thai Pongal as the second day of Pongal in Tamil Nadu).',
  where_celebrated = 'Pan-India with regional names; Gujarat''s International Kite Festival; Ganga and Godavari ghats for snan; rural fields for cattle decoration in parts of Karnataka and Maharashtra; Assam for Bihu feasts; Punjab for Lohri bonfires preceding Maghi.',
  how_celebrated = 'Holy bath at rivers, Surya arghya, charity (blankets, food, til donations), preparation of pongal/khichdi/payasam, kite duels with manjha string in Gujarat, bonfires and folk songs in North India, sugarcane and ellu-bella exchange in Karnataka. Many begin spiritual vows or pilgrimages (e.g., Gangasagar).',
  history = 'Mahabharata references Bhishma choosing Uttarayana for his final departure. Pancharatra and medieval digests codified sankranti snan. Regional harvest rites predate and merge with the solar festival.',
  significance = 'Uttarayana is considered spiritually favourable; the festival ties cosmic rhythm to agriculture, health (winter foods), and generosity. It expresses pan-Indian unity through diversity of local names and customs.',
  scriptures_related = 'Mahabharata (Bhishma Parva); Puranas discussing Uttarayana and Dakshinayana; regional harvest oral traditions; Jyotisha shastras on sankranti.',
  updated_at = now()
WHERE slug = 'makar-sankranti';

UPDATE public.hindu_festivals SET
  short_description = 'Raksha Bandhan: the sacred thread of protection—sisters and brothers, gifts, and vows rooted in epic and Puranic lore.',
  description = 'Raksha Bandhan (“bond of protection”) centres on a sister tying a rakhi (amulet thread) on her brother''s wrist; the brother offers gifts and a pledge to guard her well-being. The practice extends to cousins, family friends, and in modern civic contexts to soldiers and neighbours, symbolizing mutual care beyond blood. Mythic precedents include Draupadi tearing her sari to bind Krishna''s wound and King Bali receiving Lakshmi with Vishnu as Vamana. The festival occurs in Shravana, a month rich in monsoon festivals, and strengthens kinship networks across distances.',
  when_celebrated = 'Shravana Purnima (full moon of Shravana).',
  when_details = 'Typically August. The auspicious moment (muhurta) for tying the rakhi is often calculated by family priests or panchang apps; some regions observe variations like Avani Avittam overlap in the South for different rites the same season.',
  where_celebrated = 'North, West, and Central India; Nepal; global diaspora with mailed rakhis and video calls. Coastal and Jain communities sometimes emphasize different Shravana rituals, but rakhi culture has spread widely through media and migration.',
  how_celebrated = 'Sisters prepare a thali with lamp, rice tilak, sweets, and rakhi; brothers may give cash or gifts; families feast together. Some temples distribute sacred threads; schools and NGOs organize events for inclusivity. Eco-friendly fabric or seed-paper rakhis are increasingly popular.',
  history = 'Medieval Rajput and Maratha narratives linked rakhi to political protection treaties. Colonial calendars popularized it as a pan-Hindu sibling festival. Television and advertising shaped its gift economy.',
  significance = 'The festival articulates dharma of protection and gratitude between genders within kinship. It can also be reinterpreted as a general pledge to stand by those who are vulnerable.',
  scriptures_related = 'Mahabharata (Krishna–Draupadi episode); Bhavishya Purana (Bali–Lakshmi); Vishnu Purana context for Vamana; Grhya sutras on full-moon domestic rites.',
  updated_at = now()
WHERE slug = 'raksha-bandhan';

UPDATE public.hindu_festivals SET
  short_description = 'Janmashtami: midnight birth of Krishna—fasts, cradle songs, and Dahi Handi remembering his butter-thieving childhood.',
  description = 'Krishna Janmashtami marks the birth of Krishna in Mathura to Devaki and Vasudeva, eighth child destined to slay the tyrant Kamsa. Scriptures describe how Vasudeva carried the infant across the Yamuna to Gokul. Devotees observe fasting (often until midnight), sing bhajans, bathe and rock the baby Krishna icon (jhulan), and in Maharashtra enact Dahi Handi—human pyramids breaking a suspended pot of curd, echoing Krishna''s mischievous raids on gopis'' churned butter. Temples in Mathura, Vrindavan, Dwarka, and Udupi draw vast crowds; ISKCON and other movements have globalized kirtan-filled celebrations.',
  when_celebrated = 'Bhadrapada Krishna Ashtami (eighth day of the dark fortnight of Bhadrapada).',
  when_details = 'Usually July–August. When tithi spans two midnights, some sects observe on the second night (Rohini nakshatra overlap rules vary); temples announce the accepted local siddhanta.',
  where_celebrated = 'Pan-India; peak pilgrimage in Braj Mandal, Gujarat, Maharashtra, Rajasthan, and South Indian Krishna temples. Worldwide Hindu temples and cultural centres host midnight arati and cultural programmes.',
  how_celebrated = 'Fasting, reading Bhagavata Purana (canto 10), abhishekam of Krishna murti with panchamrita, swinging the deity, tableaux of Krishna lila, Dahi Handi with safety regulations, and distribution of panjiri or chappan bhog in some traditions.',
  history = 'Bhagavata Purana and Harivamsa narrate the birth legend. Medieval Bhakti saints (Chaitanya, Vallabha, Nimbarka lineages) intensified emotional worship. Colonial ethnography and cinema spread Dahi Handi imagery.',
  significance = 'Janmashtami celebrates divine descent (avatara) to restore dharma, the intimacy of bhakti (God as child and friend), and the transformation of ordinary life into lila through devotion.',
  scriptures_related = 'Bhagavata Purana (Skandha 10); Vishnu Purana; Harivamsa; Brahma Vaivarta Purana; Gita Govinda; regional padavalis.',
  updated_at = now()
WHERE slug = 'janmashtami';

UPDATE public.hindu_festivals SET
  short_description = 'Maha Shivaratri: the great night of Shiva—fasting, bilva, and vigil honouring cosmic stillness and the marriage of Shiva-Parvati.',
  description = 'Maha Shivaratri is the principal annual observance dedicated to Shiva. Devotees fast (some fully, some with fruit/milk), stay awake through the night (jagaran), and perform repeated abhishekam on the linga with water, milk, honey, bilva leaves, and bel fruit. Multiple origin stories coexist: Shiva as Neelakantha drinking halahala poison during samudra manthan; Shiva performing the Tandava; the divine wedding of Shiva and Parvati; and the Lingodbhava legend of limitless light. The night is understood as especially potent for mantra, meditation, and dissolution of ignorance.',
  when_celebrated = 'Phalguna Krishna Chaturdashi (14th night of the waning moon in Phalguna).',
  when_details = 'Typically February–March. Four night watches (praharas) structure temple worship; Nishitha kaal is often emphasized for linga abhishekam. Some regions also honour the following morning.',
  where_celebrated = 'Pan-India; massive gatherings at Varanasi, Ujjain (Mahakaleshwar), Somnath, Kedarnath, and Tamil Nadu''s Pancha Bhoota Sthalams. Nepal and diaspora temples maintain all-night programmes.',
  how_celebrated = 'Linga or murti puja, chanting of Om Namah Shivaya and Rudram, bilva archana, havan in some communities, pilgrimage to jyotirlingas, and charity. Kashmiri Pandits and other groups have distinctive vrata stories; Adivasi and regional Shaiva traditions add local processions.',
  history = 'Puranas (Shiva, Linga, Skanda) narrate competing etiologies. Tantric and Agamic temple manuals prescribe Maha Shivaratri protocols. The festival intersects with pre-lent Carnival season only by calendar coincidence in some years—not by origin.',
  significance = 'Maha Shivaratri supports tapas (austerity), night vigil as symbolic overcoming of inner darkness, and recognition of Shiva as destroyer of evil, lord of yoga, and compassionate householder with Parvati.',
  scriptures_related = 'Shiva Purana; Linga Purana; Skanda Purana; Padma Purana; Rudram from Yajurveda (Shri Rudram, Chamakam); Shaiva Agamas.',
  updated_at = now()
WHERE slug = 'maha-shivaratri';

UPDATE public.hindu_festivals SET
  short_description = 'Onam: Kerala''s harvest flower carpets and Onasadya—welcoming the legendary King Mahabali with boat races and tiger dance.',
  description = 'Onam is Kerala''s state festival, rooted in agrarian abundance and the legend of Mahabali (Maveli), a generous asura king whom Vishnu as Vamana sent to patala but allowed to visit his subjects annually. Homes create intricate pookkalam (flower rangoli), wear new mundu and kasavu, and serve Onasadya—a vegetarian feast on banana leaf with dozens of dishes. Vallamkali (snake boat races), Pulikali (body-painted tiger dance), Thiruvathirakali, and Onathappan clay pyramids fill the cultural calendar. The festival transcends single sect, uniting Hindus, Christians, and Muslims in many Keralite civic events while retaining Hindu mythic framing.',
  when_celebrated = 'First month Chingam in Malayalam calendar (solar sidereal).',
  when_details = 'Usually August–September (10-day Thiruonam culminating on Thiruvonam nakshatram). Schools and offices often declare holidays across the period; major events cluster on Uthradom and Thiruvonam.',
  where_celebrated = 'Kerala statewide; Gulf countries with Malayali workforce; global Malayali associations in North America, Europe, and Australia.',
  how_celebrated = 'Daily pookkalam layering, buying new clothes, sadya with payasam varieties, gifting, visits to elders, boat races on Pampa and backwaters, swing games for children, and in some areas worship of Vamana or Onathappan figures. Tourism packages highlight houseboat Onam experiences.',
  history = 'Bhagavata Purana Vamana narrative underlies the Mahabali myth. Sangam-era poetry references seasonal festivals; medieval kingdoms patronized boat regattas. Modern Onam became a symbol of Kerala''s unified regional identity post-state formation.',
  significance = 'Onam expresses gratitude for harvest, memory of a just ruler, and artistic excellence in cuisine and floral design. It supports local floriculture, handloom, and performing arts economies.',
  scriptures_related = 'Bhagavata Purana (Vamana avatara); regional sthalapuranas; Malayalam ballads and Onam songs (Onappattukal).',
  updated_at = now()
WHERE slug = 'onam';

UPDATE public.hindu_festivals SET
  short_description = 'Thai Pongal: Tamil harvest thanksgiving—boiling the overflowing pot for Surya, honouring cattle, and four days of kolam and sweets.',
  description = 'Pongal is a four-day Tamil festival aligned with the sun''s Uttarayana (often contiguous with Makar Sankranti). Bhogi begins with discarding old items and bonfires; Thai Pongal is the main day when fresh rice is cooked with milk and jaggery until it boils over (“pongal-o pongal”), shouted as auspicious overflow. Mattu Pongal honours cattle with decoration and sweet rice; Kaanum Pongal is for outings and family reunions. Kolam designs, sugarcane stalks, and turmeric-smeared pots mark doorways. The festival encodes Dravidian agrarian cosmology—sun, earth, rain, and bullocks as partners in survival.',
  when_celebrated = 'Tamil month Thai (begins with Sankranti).',
  when_details = 'Mid-January. Bhogi is the day before Thai Pongal; Mattu and Kaanum follow. Jallikattu events in Tamil Nadu occur around Mattu Pongal under regulated conditions.',
  where_celebrated = 'Tamil Nadu, Puducherry, Tamil populations in Sri Lanka, Malaysia, Singapore, Mauritius, South Africa, and Western diaspora cities.',
  how_celebrated = 'Ritual cooking outdoors in new earthen pots tied with ginger and turmeric, sun and cattle puja, new clothes, sweets (vadai, payasam), village fairs, and in some areas traditional sports. Urban apartments adapt with balcony pongal pots and community hall kolam contests.',
  history = 'Sangam literature references comparable harvest rites. Chola and Pandya inscriptions record temple grants during harvest months. Contemporary Pongal reinforces Tamil linguistic and cinematic culture.',
  significance = 'Pongal makes visible dependence on nature and livestock, gratitude to farmers, and intergenerational gathering. It parallels pan-Indian Makar Sankranti while keeping distinct Tamil names and idioms.',
  scriptures_related = 'Oral agrarian tradition more than single Puranic text; alignments with solar jyotisha; modern Hindu calendars integrating Thai month.',
  updated_at = now()
WHERE slug = 'pongal';

UPDATE public.hindu_festivals SET
  short_description = 'Chhath Puja: standing in river water at sunrise and sunset—ancient sun worship, strict vrata, and offerings to Chhathi Maiya.',
  description = 'Chhath Puja is a rigorous four-day observance dedicated to Surya (rising and setting sun) and Chhathi Maiya (Shashthi Devi), protector of children. Women and men undertake nirjala or partial fasts, maintain purity, and offer arghya while standing waist-deep in rivers or ponds—sandhya arghya on Kartik Shukla Shashthi evening and usha arghya the next dawn. Thekua, seasonal fruits, sugarcane, and coconut compose the prasad. The festival is culturally dominant in the Gangetic plain and Terai, with extraordinary mass participation at ghats in Patna, Varanasi, and Janakpur.',
  when_celebrated = 'Kartik Shukla Shashthi (sixth day of bright fortnight of Kartik), with preparatory days before.',
  when_details = 'Usually November, shortly after Diwali. Nahay-Khay (bath and simple meal), Kharna (kheer preparation), evening arghya, night vigil, morning arghya, and breaking the fast form the sequence across four days.',
  where_celebrated = 'Bihar, Jharkhand, Eastern Uttar Pradesh, Nepal Terai, Madhesh; migrant communities in Delhi NCR, Mumbai, Bengaluru, and abroad (Mauritius, Fiji, UK, USA).',
  how_celebrated = 'Strict cleanliness, fasting protocols, bamboo baskets (soop) of offerings, decorated ghats, folk songs (geet), and family processions. Many wear single-use traditional attire; NGOs promote biodegradable materials.',
  history = 'Rigvedic hymns to Surya provide distant Vedic resonance; Mahabharata legend links Draupadi''s Chhath-like observance to recovery from hardship. The festival as today''s mass women-led public ritual crystallized in modern Bihar–Nepal border culture.',
  significance = 'Chhath expresses gratitude for solar energy, fertility, and child welfare; the austerity builds communal discipline and ghat solidarity across caste in many locales.',
  scriptures_related = 'Rig Veda (Surya suktas); Mahabharata (Vana Parva associations in folk retelling); regional vrata kathas; Kashi and Mithila oral traditions.',
  updated_at = now()
WHERE slug = 'chhath-puja';

UPDATE public.hindu_festivals SET
  short_description = 'Vasant Panchami: yellow spring, Saraswati puja, and the blessing of books—inaugurating learning and the mustard bloom.',
  description = 'Vasant Panchami falls on Magha Shukla Panchami, heralding spring (vasant). Yellow—mirroring mustard fields—dominates clothing and food. Saraswati, goddess of knowledge, music, and speech, is worshipped in schools, universities, and homes; instruments and books are placed before her for blessing (some avoid reading all day until puja). Children begin aksharabhyas (first writing) in many communities. Kite flying links the festival to wind and sky in North India. The day sits within a broader season moving from cold dormancy toward renewal.',
  when_celebrated = 'Magha Shukla Panchami.',
  when_details = 'Usually late January to February. Panchami tithi timing determines the calendar day; institutions often fix a school-wide celebration date nearby.',
  where_celebrated = 'Pan-India, especially strong in Bengal (Saraswati Puja as a major student festival), Punjab, Uttar Pradesh, Bihar, Odisha, and Nepal. Bali and Indonesian Hindu communities also honour Saraswati (e.g., Hari Raya Saraswati).',
  how_celebrated = 'Saraswati murti or picture with white/yellow flowers, boondi or yellow sweets, veena iconography, processions with idols to rivers for immersion in Bengal, kite duels in Punjab and Gujarat-adjacent areas, and cultural competitions in schools.',
  history = 'Puranic and Agamic texts exalt Saraswati. Medieval courts patronized spring poetry assemblies. Colonial education institutions syncretized Saraswati Puja with school annual days.',
  significance = 'The festival sacralizes education and arts, encourages beginners, and marks seasonal optimism. It balances Diwali–spring calendar with an explicitly intellectual emphasis.',
  scriptures_related = 'Devi Mahatmya (Saraswati mentions); Brahma Vaivarta Purana; Padma Purana; Saraswati Rahasya Upanishad; Yajurvedic homage to Vac as precursor themes.',
  updated_at = now()
WHERE slug = 'vasant-panchami';

UPDATE public.hindu_festivals SET
  short_description = 'Ugadi / Yugadi: Deccan New Year with six-taste pachadi—Chaitra Pratipada and the almanac''s new cycle.',
  description = 'Ugadi (Kannada/Telugu) or Yugadi marks Chaitra Shukla Pratipada, the first day of the lunisolar year in many South Indian calendars. The day begins with oil bath, temple visit, and reading the new Panchanga (Ugadi Pacharadana) to learn the year''s forecast (neither fatalistic nor ignored—it frames mindset). Ugadi pachadi combines six tastes (sweet, sour, salty, bitter, pungent, tangy) to symbolize mixed experiences in the year ahead. Mango leaves toran and raw mango dishes signal arrival of spring heat and fruit.',
  when_celebrated = 'Chaitra Shukla Pratipada.',
  when_details = 'March–April. Same tithi as Gudi Padwa in Maharashtra and Cheti Chand for some Sindhi communities—regional calendars share the new-year node with local names.',
  where_celebrated = 'Karnataka, Andhra Pradesh, Telangana; related observances in Maharashtra and Konkan. Diaspora temples in the United States and elsewhere broadcast panchanga recitals.',
  how_celebrated = 'Pachadi preparation, bevu-bella (neem-jaggery) in Karnataka symbolism, new clothes, rangoli, listening to classical renditions of panchanga sravanam, charitable giving, and family meals featuring holige/obattu in some homes.',
  history = 'Regional kingly calendars (Shalivahana era associations in folk memory) and almanac (panchanga) tradition anchor the date. Puranic creation motifs link Chaitra to cosmic renewal in commentarial literature.',
  significance = 'Ugadi encourages acceptance of life''s complexity, astrological-cultural literacy, and linguistic pride (Kannada/Telugu New Year speeches by leaders).',
  scriptures_related = 'Brahma Purana (Chaitra month sanctity); Jyotisha panchanga shastras; regional neeti-shataka-style reflections on the six rasas.',
  updated_at = now()
WHERE slug = 'ugadi';

UPDATE public.hindu_festivals SET
  short_description = 'Rama Navami: birth of Maryada Purushottam in Ayodhya—fasts, Ramayana path, and processions for the seventh avatara of Vishnu.',
  description = 'Rama Navami celebrates the birth of Rama at Ayodhya to Dasharatha and Kaushalya, seventh incarnation of Vishnu and exemplar of dharma in kingship, marriage, and exile. Devotees fast until noon (Rama''s birth moment), recite Valmiki or Tulsi Ramayana, sing Ram bhajans, and attend temple abhishekam of baby Rama icons. Bhadrachalam (Telangana), Rameswaram, and Ayodhya draw huge pilgrimages; some regions combine with Chaitra Navratri''s ninth day. The festival reinforces ideal relationships—Rama-Sita, Rama-Lakshmana, Rama-Hanuman—as ethical templates.',
  when_celebrated = 'Chaitra Shukla Navami.',
  when_details = 'March–April. Madhyahna (midday) is considered birth time in many panchangas; temples announce abhishekam schedules; some observe nine-day vrata culminating on Navami.',
  where_celebrated = 'Pan-India; focal centres Ayodhya, Bhadrachalam, Rameswaram, Sitamarhi; Caribbean and Fijian Hindu communities; diaspora mandirs with Ramayana recitation marathons.',
  how_celebrated = 'Fasting, panakam and kosambari prasad in South India, haldi-kumkum gatherings for women in Maharashtra, chariot processions where permitted, Ramayana paath, and distribution of food to the needy as seva.',
  history = 'Valmiki Ramayana and later Ramcharitmanas shaped liturgy. Medieval Ramanandi and other sampradayas institutionalized temple birthdays. Modern Ayodhya Ram Mandir consecrations intensified global attention on Rama Navami.',
  significance = 'The festival affirms righteous rule (ramarajya), steadfast partnership, obedience to dharma even in suffering, and bhakti to Rama as accessible lord.',
  scriptures_related = 'Valmiki Ramayana; Ramcharitmanas; Adhyatma Ramayana; Vishnu Purana; Bhagavata Purana (eleventh skandha echoes); regional Ramayana oral traditions.',
  updated_at = now()
WHERE slug = 'rama-navami';

UPDATE public.hindu_festivals SET
  short_description = 'Karwa Chauth: dawn-to-moonrise fast by married women—sargi, evening thali, and prayers for spouse longevity.',
  description = 'Karwa Chauth is observed mainly in North India by married women who fast without water from sunrise until moonrise, breaking the fast after sighting the moon through a sieve and offering arghya. Mothers-in-law often give sargi (pre-dawn meal); evening gatherings involve storytelling of Veeravati or Savitri-Satyavan legends, henna, and finery. The karwa (earthen pot) symbolizes water and prosperity. While critiqued in some feminist discourse, many participants describe it as chosen austerity, sisterhood, and aesthetic tradition; families increasingly adapt rules for health needs.',
  when_celebrated = 'Kartik Krishna Chaturthi (fourth day of the waning fortnight of Kartik).',
  when_details = 'Typically October or early November, a few days after Diwali season depending on lunar calendar. Moonrise time determines breaking of fast; apps and community announcements coordinate group sightings.',
  where_celebrated = 'Punjab, Haryana, Rajasthan, Uttar Pradesh, Madhya Pradesh, parts of Gujarat and Himachal; Nepali and diaspora communities in UK, USA, Canada. Bollywood films amplified its visibility.',
  how_celebrated = 'Sargi before dawn, day-long vrata, evening puja with karwa, diya on water vessel, Katha recitation, moon sighting through sieve with husband present, first sip of water from husband''s hand, then meal.',
  history = 'Folk narratives tie the vrata to military wives in medieval Punjab–Rajasthan border culture; Savitri Mahatmya from Mahabharata provides a classical template for wife''s steadfastness. Commercialization of sargi hampers and gifts is recent.',
  significance = 'Expresses marital commitment and intergenerational female bonding; also sparks discussion on equitable fasting and health-informed practice.',
  scriptures_related = 'Mahabharata (Vana Parva, Savitri); folk Karwa Chauth vrat katha pamphlets; not a single Puranic book festival but embedded in grhya-style vrata culture.',
  updated_at = now()
WHERE slug = 'karwa-chauth';

UPDATE public.hindu_festivals SET
  short_description = 'Mahalaya: ancestors'' fortnight meets Devi''s descent—tarpan, “Mahishasura Mardini” radio, and the start of Durga season.',
  description = 'Mahalaya Amavasya ends Pitru Paksha (fortnight for ancestors) and, in Bengal and Odisha, marks the eve of Devi Paksha—spiritually “inviting” Goddess Durga to earth. Bengalis wake early to hear recorded or live recitation of Chandipath and the iconic Mahishasura Mardini broadcast tradition begun by Birendra Krishna Bhadra. Families perform tarpan at rivers, offering pinda to forefathers. Artisan workshops finish painting Durga''s eyes (Chokkhu Dan). The day stitches memory of lineage to communal anticipation of Durga Puja.',
  when_celebrated = 'Ashvina Amavasya (new moon before Sharad Navratri).',
  when_details = 'Usually late September or October. Exact transition from pitru to devi paksha depends on local tithi; radio and streaming schedules still anchor collective listening at dawn.',
  where_celebrated = 'West Bengal, Odisha, Assam, Tripura; Bengali diaspora; parallel pitru tarpan customs across India on the same amavasya.',
  how_celebrated = 'Tarpan and shraddha offerings, listening to Mahishasura Mardini, visiting ghats, beginning Durga idol rituals, cleaning homes for upcoming puja, and charity for ancestors (brahman bhoj).',
  history = 'Markandeya Purana''s Devi Mahatmya is recited; All India Radio''s 1930s programme became cultural glue. Pitru paksha rites derive from shraddha shastras.',
  significance = 'Honours ancestors as spiritual debt (rna), turns grief into structured remembrance, and pivots the emotional calendar from solemnity to festive Devi worship.',
  scriptures_related = 'Markandeya Purana (Devi Mahatmyam); Garuda Purana (shraddha sections); Vishnu Smriti and shraddha paddhatis.',
  updated_at = now()
WHERE slug = 'mahalaya';

UPDATE public.hindu_festivals SET
  short_description = 'Vijayadashami / Dussehra: Rama burns Ravana, Durga wins, and new learning begins—India''s great “Victory Tenth.”',
  description = 'Vijayadashami is the tenth day of Ashvina Shukla paksha, concluding Navratri. It commemorates Rama''s victory over Ravana (Ramayana) and Durga''s over Mahishasura (Devi Mahatmyam). North Indian Ramlila grounds culminate in giant effigy burnings of Ravana, Kumbhakarna, and Meghanada; Eastern India immerses Durga idols after sindoor play; South India blesses weapons, tools, and children''s writing (Ayudha/Vidyarambham). The convergence of multiple regional emphases on one tithi makes it one of Hinduism''s most polyphonic festivals.',
  when_celebrated = 'Ashvina Shukla Dashami.',
  when_details = 'September–October. Some regions transfer certain rituals to Navami if dashami is short; immersion tides and police-managed processions follow municipal schedules.',
  where_celebrated = 'Pan-India: Delhi–Agra–Indore Ramlila effigies; Kullu Dussehra; Mysuru Dasara palace procession; Bengal–Odisha visarjan; Kerala Vidyarambham at temples; Nepal Dashain overlaps nearby.',
  how_celebrated = 'Ravana dahan with fireworks, Shami leaf exchange (aptya) as symbolic gold in Maharashtra, Durga visarjan processions, Ayudha puja of vehicles and machines in Tamil Nadu and Karnataka, initiation of children''s alphabet in Kerala and parts of Karnataka, and community feasts.',
  history = 'Epic and Puranic narratives fused with medieval Vijayanagara and Maratha state festivals. British colonial gazetteers documented Ramlila as public order events. Modern eco-visarjan and artificial ponds address immersion impacts.',
  significance = 'Encapsulates moral victory, renewal of tools and learning, and closure of the Navratri energy arc. It is considered shubh muhurat for new enterprises.',
  scriptures_related = 'Ramayana; Devi Mahatmyam; Mahabharata (related themes); Agni Purana and regional paddhatis for Ayudha puja.',
  updated_at = now()
WHERE slug = 'vijayadashami';
