-- Rich narrative content for craft_hubs (Indian crafts map/detail).
-- Each hub text links the object to lived Indian culture: festivals, temple and
-- home shrines, weddings, vratas, storytelling, pilgrimage souvenirs, and GI heritage.
-- Does NOT touch cover_image_url, gallery_urls, id, slug, name, region, state,
-- latitude, longitude, craft_name, discussion_site_id, sort_order, or is_published.

UPDATE public.craft_hubs SET
  short_description = 'Channapatna gombegala ooru: lac-turned wooden toys and décor on lathes—vegetable-dye lac sticks melted onto spinning ale-mara (wrightia) wood for glossy, child-safe colour bands.',
  about_place_and_craft = 'The Ramanagara district town supplies India''s best-known educational toy cluster; artisans work in household sheds and registered societies. Products span rattles, puzzles, kitchen miniatures, and corporate gifts. Karnataka government and Cauvery emporia market GI-linked Channapatna craft.',
  history = 'Tipu Sultan–era links appear in promotional lore; twentieth-century Japanese design collaboration introduced new forms; export orders and Flipkart/Amazon clusters scaled production while NGOs police lead-free lac.',
  cultural_significance = 'In Indian homes these lac-turned toys mark auspicious births, Golu steps, and temple-fair gifts—Karnataka''s GI-linked answer to plastic imports, valued as tactile child-safe craft.',
  making_process = 'Season wood rounds on lathe with foot or motor; shape with chisel; apply coloured lac while friction-melting from sticks; burnish; sometimes hand-paint details.',
  materials = 'Wrightia tinctoria (aale mara) or related softwood; shellac-based coloured lac; occasionally natural pigments in revival lines.',
  motifs_and_style = 'Bright concentric stripes, minimalist animal silhouettes, rattles with internal jingle pegs, stacking rings.',
  care_and_authenticity = 'Buy from Cauvery/Karnataka One tagged outlets; surface should smell faintly of lac, not synthetic enamel; avoid chipped lac for infants.',
  best_buying_season = 'October–February for craft fairs; year-round in Channapatna lanes. Monsoon affects lac drying—inspect storage.',
  updated_at = now()
WHERE slug = 'channapatna-toys';

UPDATE public.craft_hubs SET
  short_description = 'Kondapalli bommalu: light tella poniki wood figurines—processions, Dasavataram sets, village tableaux, and festival dolls assembled with sawdust tamarind paste and poster colours.',
  about_place_and_craft = 'Near Vijayawada, the craft village sells wholesale to seasonal markets; layers of scrap wood form bases, then carved faces and costumes. Export demand favours flat-pack nativity-style sets.',
  history = 'Nayaka-period patronage narratives; Andhra Pradesh Handicrafts (Lepakshi) marketing; competition from Chinese decor keeps price pressure on artisans.',
  cultural_significance = 'Central to Telugu Sankranti bommala koluvu, Dasavataram sets, and Dasara tableaux—mythic dolls that teach Ramayana and village life during festival time.',
  making_process = 'Split poniki wood, carve limbs, join with adhesive paste, smooth with sand, prime, paint with brushes, fix ornaments.',
  materials = 'Tella poniki (soft white wood), tamarind–sawdust bond, acrylic or distemper, sometimes gold foil highlights.',
  motifs_and_style = 'Bobbili raja sets, village marriage scenes, Ramayana chariots, Ambari elephants.',
  care_and_authenticity = 'Hand-painted edges blur slightly vs screen print; buy from cooperative society; keep dry—joints swell in humidity.',
  best_buying_season = 'September–February; peak before Sankranti and Dasara.',
  updated_at = now()
WHERE slug = 'kondapalli-toys';

UPDATE public.craft_hubs SET
  short_description = 'Bidriware: zinc-rich alloy cast vessels engraved and inlaid with silver wire, then soil–ammonium chloride paste turns surface charcoal-black while silver gleams.',
  about_place_and_craft = 'Bidar''s workshops produce huqqa bases, vases, jewellery boxes, and contemporary décor. Inlay (tarkashi) requires chisel-cut grooves, hammered silver strip, and secret blackening recipe including Bidar fort soil.',
  history = 'Bahmani and Barid Shah court craft; Persian metalwork kinship; GI registration (2006); decline in master inlayers spurred design school interventions.',
  cultural_significance = 'Chosen for Deccan weddings, dawat feasts, and state gifts; black-silver Bidri ties Indo-Persian metal art to Indian court and drawing-room culture across communities.',
  making_process = 'Sand casting or sheet forming, filing, engraving design, inlay silver, buff, apply oxidizing paste, wash, final polish.',
  materials = 'Zinc–copper alloy (often ~94:6), fine silver wire/sheet, Bidar soil, sal ammoniac, copper sulphate in traditional mix.',
  motifs_and_style = 'Asharfi coin patterns, creepers, tehzib calligraphy, geometric jaali on spouts.',
  care_and_authenticity = 'Heft and cool feel vs aluminium fakes; silver should stand proud after blackening; Karnataka/CII craft authentication tags help.',
  best_buying_season = 'October–March; avoid monsoon travel to workshops if flooding.',
  updated_at = now()
WHERE slug = 'bidriware';

UPDATE public.craft_hubs SET
  short_description = 'Jaipur blue pottery: quartz–glass–gum body (low plastic clay) painted with cobalt oxide and fired low—Mughal–Persian lineage filtered through Rajput workshops.',
  about_place_and_craft = 'Sanganer and Jaipur lanes make tiles, knobs, tableware, and knick-knacks; dough is fragile until fired. Lead-free glazes are marketed for food contact in certified studios.',
  history = 'Revived by Kripal Singh Shekhawat narrative; earlier decline when enamelware arrived; Jaipur Blue Pottery GI (2008).',
  cultural_significance = 'Tiles and tableware color Rajasthan homes and havelis; families also use certified lead-free pieces near puja corners, linking Jaipur''s Indo-Persian palette to daily and festival ritual space.',
  making_process = 'Mix quartz, powdered glass, Multani mitti, binders; mould or press; air dry; paint with cobalt and other oxides; dip transparent glaze; biscuit fire ~800°C.',
  materials = 'Quartz powder, glass frit, gum, cobalt carbonate, copper for turquoise, manganese for purple.',
  motifs_and_style = 'Persian floral arabesques, birds, jaal tiles, lotus borders.',
  care_and_authenticity = 'Ping sound when tapped if well-fired; crazing in glaze can be normal; verify food-safety claim for dinnerware.',
  best_buying_season = 'October–February; Jaipur Literature Festival craft stalls.',
  updated_at = now()
WHERE slug = 'jaipur-blue-pottery';

UPDATE public.craft_hubs SET
  short_description = 'Raghurajpur pattachitra: cloth treated with tamarind and chalk, painted with natural pigments and squirrel-hair brush—Jagannath triad, Krishna lila, and fine border scrollwork.',
  about_place_and_craft = 'Heritage village near Puri hosts chitrakar families; sibling crafts include palm-leaf etching and coconut carving. Tourist buses and cruise excursions sustain the economy.',
  history = 'Temple seva and pilgrim souvenir economy; GI (2008); COVID-era pivot to online and mask painting.',
  cultural_significance = 'Paintings carry Jagannath seva, Krishna lila, and Puri pilgrimage memory; they teach Puranic stories in homes and mathas, anchoring Odia bhakti in natural pigment and line.',
  making_process = 'Double-coat cloth with gum–chalk; polish stone; charcoal sketch; fill colours in sequence (white, red, black last outline); varnish optional.',
  materials = 'Tussar or cotton, tamarind seed paste, chalk powder, lamp soot, hingula red, haritala yellow, indigo, conch shell white.',
  motifs_and_style = 'Konarka chakra borders, Nabagunjara, Rasa lila panels, stylized trees and architecture.',
  care_and_authenticity = 'Brush texture visible; natural pigments matte; ask artist name and village; machine prints sold on Puri beach are not pattachitra.',
  best_buying_season = 'November–March; Rath Yatra week is peak sales.',
  updated_at = now()
WHERE slug = 'pattachitra-raghurajpur';

UPDATE public.craft_hubs SET
  short_description = 'Bastar dhokra: lost-wax brass casting with rough, golden, slightly pitted surface—horses, elephants, tribal deities, and utilitarian lamps from Kondagaon–Jagdalpur belt.',
  about_place_and_craft = 'Gharua and allied communities work in backyard furnaces; each piece is unique because original wax is lost. Dhokra coexists with wrought iron tribal craft in same haats.',
  history = 'Archaeological pride in Indus dancing girl narrative; state emporia and Tribes India retail; design interventions add functional products.',
  cultural_significance = 'Brass horses, deities, and lamps enter Adivasi shrines, village processions, and craft emporia; each casting supports ritual life as well as Chhattisgarh regional identity.',
  making_process = 'Coil beeswax–resin threads on clay core, add sprues, pack clay mould, char wax, pour molten brass, break mould, chase, patinate.',
  materials = 'Dokra clay, beeswax, scrap brass, charcoal, leaf bellows.',
  motifs_and_style = 'Ancestor couples, flute players, ankush, narrative friezes, textured animal skin.',
  care_and_authenticity = 'Weight and irregularity vs die-cast shine; buy Tribes India or documented cooperatives.',
  best_buying_season = 'October–February; Bastar Dussehra melas.',
  updated_at = now()
WHERE slug = 'dhokra-bastar';

UPDATE public.craft_hubs SET
  short_description = 'Saharanpur wood carving: sheesham and mango furniture, jali screens, inlay marquetry, and export-oriented colonial-revival pieces from India''s largest woodcraft cluster.',
  about_place_and_craft = 'Workshops line Grand Trunk Road supply Indian homes and global retailers; CNC routers now mix with hand chisels. Carvers specialize in lattice, vine relief, or brass inlay.',
  history = 'Mughal garden aesthetic meets British catalog trade; environmental scrutiny on sheesham sourcing; EPCH fairs in Delhi.',
  cultural_significance = 'Jali panels and carved furniture shape North Indian drawing rooms, mandir alcoves, and wedding trousseau; the cluster sets how carved wood reads from the GT Road to diaspora homes.',
  making_process = 'Kiln-season timber, band-saw rough shape, hand chisel detail, sand, stain, PU or melamine finish.',
  materials = 'Sheesham (Indian rosewood where permitted), mango, kadam, carving chisels, sandpaper grades, metal inlay wire.',
  motifs_and_style = 'Jaal panels, grapevine, lotus medallions, geometric fretwork.',
  care_and_authenticity = 'Check joint stability and seasoning cracks; FSC or legal timber claims for export pieces; smell of solvent indicates factory finish.',
  best_buying_season = 'October–March; IHGF Delhi Fair order season.',
  updated_at = now()
WHERE slug = 'saharanpur-wood-carving';

UPDATE public.craft_hubs SET
  short_description = 'Moradabad brass: hammered, spun, cast, and acid-etched metalware—hotelware, Islamic geometric lamps, Christmas ornaments, and Parisian boutique orders from the Peetal Nagri.',
  about_place_and_craft = 'Thousands of small units vertically integrate casting, polishing, enamelling; artisans often migrate seasonally. Quality tiers range from heavy hotel grade to thin souvenir.',
  history = 'Colonial rail and river trade; 1980s export boom; ongoing air-quality regulation on polishing shops.',
  cultural_significance = 'From puja thalis and diyas to export lanterns, Peetal Nagri backs much of what the world pictures as Indian brass; at home it supplies festival lighting and temple-style décor at many price points.',
  making_process = 'Sand casting or sheet spinning, welding seams, turning, hand engraving or chemical etch, buffing, lacquer or epoxy coat.',
  materials = 'Brass ingots, nickel silver, stainless for clad pieces, polishing compounds, enamels.',
  motifs_and_style = 'Moroccan lantern piercings, hammered texture, Art Deco revival, bespoke hotel crests.',
  care_and_authenticity = 'Magnet test for steel cores; weight vs price; food contact should be lead-free certified.',
  best_buying_season = 'September–March; align with IHGF and Christmas export cycles.',
  updated_at = now()
WHERE slug = 'moradabad-brassware';

UPDATE public.craft_hubs SET
  short_description = 'Kashmiri papier-mâché: sakhtsazi moulding from pulp layers, then naqashi miniature floral painting under lacquer—boxes, eggs, Christmas ornaments, and room screens.',
  about_place_and_craft = 'Srinagar Old City workshops; family labour divides moulding, sanding, painting, varnish. Turquoise, gold arabesque, and chinar leaf are retail favourites.',
  history = 'Sultanate-era Central Asian introduction story; Victorian mail-order; conflict and tourism cycles affect orders.',
  cultural_significance = 'Painted boxes and trays move as wedding gifts and yatra-route souvenirs; floral naqashi belongs to Kashmir''s shared luxury gift culture across faith traditions.',
  making_process = 'Pulp on clay mould, dry, cut halves, join, sand smooth, chalk base coat, paint with squirrel brush, varnish layers.',
  materials = 'Waste paper pulp, rice glue, chalk, mineral pigments, shell gold, lacquer.',
  motifs_and_style = 'Gul-andar-gul rose trellis, birds, hunting scenes, chinar, paisley.',
  care_and_authenticity = 'Hand painting shows micro brush skips; GI tags when present; avoid plastic-feel printed shells.',
  best_buying_season = 'May–October tourist window; winter for Christmas export buying in workshops.',
  updated_at = now()
WHERE slug = 'kashmir-paper-mache';

UPDATE public.craft_hubs SET
  short_description = 'Kashmir walnut carving: deep relief on seasoned juglans regia—folding tables, screens, Quran stands, and panels with chinar, iris, and arabesque under wax polish.',
  about_place_and_craft = 'Srinagar, Sopore, and Pulwama sustain workshops; wood is air-seasoned years before carving. Joint screens (jali) and tilt-top tables are prestige exports.',
  history = 'Mughal and Dogra court demand; partition split markets; political unrest and walnut blight challenge supply.',
  cultural_significance = 'Carved screens and tables grace Kashmiri Pandit and Muslim households; chinar and arabesque motifs signal heirloom identity alongside textiles in high-trust gifting.',
  making_process = 'Select grain pattern, chalk design, rough chisel, fine chisel, file details, sand progressively, oil or wax finish.',
  materials = 'Kashmir walnut (closed grain), chisels, mallet, sandpaper, linseed oil, beeswax polish.',
  motifs_and_style = 'Deep undercut chinar, rose, lotus, trellis, hunting vignettes.',
  care_and_authenticity = 'Feel weight and continuous grain; machine CNC copies lack undercut depth; JKTDCo outlets help provenance.',
  best_buying_season = 'April–October tourist season; dry months best for shipping furniture.',
  updated_at = now()
WHERE slug = 'kashmir-walnut-carving';

UPDATE public.craft_hubs SET
  short_description = 'Rogan: Kutchi castor-oil-based pigment paste trailed from a kalam (metal stylus), folded for mirror symmetry—tree of life bridal cloths from Nirona''s Khatri families.',
  about_place_and_craft = 'Only a few households practice true rogan; paste is boiled oil and pigment, kept maliable on palm. Designs are drawn freehand, then pressed to duplicate.',
  history = 'Nearly extinct until 1980s documentation; PM gifts raised profile; GI (2019) for Rogan painting.',
  cultural_significance = 'Symmetrical tree-of-life cloths seal Kutch bridal trousseaus; the Khatri Muslim rogan tradition sits inside wider Gujarati Hindu wedding and festival visual culture.',
  making_process = 'Heat castor oil, add pigment to thick paste; draw with rod on stretched cloth; fold; open; fix with mild heat.',
  materials = 'Castor oil, mineral pigments, cotton cloth, metal stylus.',
  motifs_and_style = 'Symmetrical tree of life, peacocks, floral mandorlas, jewel tones on dark ground.',
  care_and_authenticity = 'Buy only from documented Nirona families; screen-print rogan-look fabrics are unrelated.',
  best_buying_season = 'November–February; Rann Utsav tourist buses.',
  updated_at = now()
WHERE slug = 'kutch-rogan-art';

UPDATE public.craft_hubs SET
  short_description = 'Madhubani (Mithila) painting: double-line kachni or colour-filled bharni on paper, cloth, and walls—gods, weddings, nature, and social critique in jewel-bright planes.',
  about_place_and_craft = 'Jitwarpur, Ranti, and Madhubani town host national awardee women artists; men''s studio works now common. Cooperatives handle export framing.',
  history = '1934 earthquake documentation; 1960s craft marketing; GI (2007); biennale and NFT experiments.',
  cultural_significance = 'Kohbar ghar and wedding walls, vrata diagrams, and village facades—women''s ritual geometry that moved to paper and global galleries while keeping Mithila life-cycle meaning.',
  making_process = 'Bamboo nib or brush; natural or acrylic fill; border first; figure hierarchy by size encodes story.',
  materials = 'Handmade paper, cloth, cow-dung wash base on walls, soot black, turmeric, indigo, lac red.',
  motifs_and_style = 'Kohbar ghar symbols, fish, peacock, snake hood, Tantric yantras in tantric lineages.',
  care_and_authenticity = 'Signed artist copy vs tourist knockoff; natural pigment fades gracefully; ask village provenance.',
  best_buying_season = 'October–March; Delhi crafts melas post-Diwali.',
  updated_at = now()
WHERE slug = 'madhubani-painting';

UPDATE public.craft_hubs SET
  short_description = 'Cheriyal nakashi: long vertical scrolls on khadi-sized cloth with tamarind–rice gum base—bold Telugu narrative panels for padagalu singers, plus masks for drama.',
  about_place_and_craft = 'Cheriyal town (Jangaon district) Vaikuntam family and others supply museums; scroll width standardized for unrolling rhythm.',
  history = 'GI (2010); decline of wandering performers shifted sales to décor; UNICEF health scrolls pilot.',
  cultural_significance = 'Narrative scrolls unroll beside padagalu singers—Telangana''s painted bridge between oral epic, village performance, and Hindu story cycles.',
  making_process = 'Size cloth, coat with tamarind paste, whiten, sketch grid, poster colours, outline black, varnish optional.',
  materials = 'Khadi cotton, tamarind, rice paste, natural or poster colours, squirrel brush.',
  motifs_and_style = 'Markandeya Purana strips, local legends, red earth backgrounds, large-eyed figures.',
  care_and_authenticity = 'Hand unevenness in border; artist signature in Telugu; avoid plasticised prints.',
  best_buying_season = 'November–February; Sankranti craft demand.',
  updated_at = now()
WHERE slug = 'cheriyal-scrolls';

UPDATE public.craft_hubs SET
  short_description = 'Etikoppaka lacware: ankudu wood turned toys and tableware coloured with lac—natural toy cluster parallel to Channapatna with distinct Andhra palette and GI tag.',
  about_place_and_craft = 'East Godavari village cluster; women polish while men turn. Focus on lacquered cups, rattles, and ladles marketed as food-safe when tested.',
  history = 'Coastal trade wood access; Design Council India awards; ecommerce enablement post-2010.',
  cultural_significance = 'Lac cups and rattles pair with Kondapalli dolls in Andhra festival gifting; natural-dye GI toys fit Golu return gifts and eco-conscious puja households.',
  making_process = 'Turn wood, friction-melt lac sticks like Channapatna; sometimes shellac top coat; buff on lathe.',
  materials = 'Wrightia and ankudu softwoods, seedlac colours, buffing cloth.',
  motifs_and_style = 'Simpler forms than Channapatna—utilitarian curves, two-tone bands.',
  care_and_authenticity = 'GI Etikoppaka toys; cooperative hologram when available; heat can re-melt lac—avoid cars in sun.',
  best_buying_season = 'October–February.',
  updated_at = now()
WHERE slug = 'etikoppaka-toys';

UPDATE public.craft_hubs SET
  short_description = 'Tanjore painting: jackfruit wood panel, chalk gesso relief, 22k gold foil, glass cabochons, and deity iconometry—Tamil Nadu''s baroque devotional panel art.',
  about_place_and_craft = 'Thanjavur lanes and Chennai studios; Chettinad merchants spread style. Commercial grades use imitation gold and printed backgrounds.',
  history = 'Maratha court of Thanjavur; Tanjore painting GI application discourse; CNC cut boards today.',
  cultural_significance = 'Gold-foil god panels hang in Tamil home shrines, are exchanged at weddings, and serve as temple donor plaques—South India''s baroque darshan image in pigment and relief.',
  making_process = 'Prepare board, paste cloth, chalk relief moulding, apply foil with adhesive, punch stones, paint faces and clothing, frame.',
  materials = 'Jackfruit wood, chalk powder, Arabic gum, gold leaf, Jaipur stones, poster colours.',
  motifs_and_style = 'Balakrishna, Rama pattabhishekam, composite Ganesha, arches and curtains.',
  care_and_authenticity = 'Tap relief for genuine depth; real gold retains lustre; ask karat and artist studio.',
  best_buying_season = 'October–March; wedding season peaks.',
  updated_at = now()
WHERE slug = 'thanjavur-painting';

UPDATE public.craft_hubs SET
  short_description = 'Mahabalipuram stone carving: granite and soapstone icons, relief panels, and garden sculpture continuing Pallava shoreline sculptural lineage.',
  about_place_and_craft = 'Shops along Othavadai Street copy Arjuna''s Penance motifs; master sthapathis supply temples across India and diaspora mandirs.',
  history = 'UNESCO shore temple zone; pneumatic tools debate; export of heavy icons by sea container.',
  cultural_significance = 'Granite vigrahas, temple door guardians, and monastery gifts flow from these lanes into mandirs across India and the diaspora—living extension of Pallava sculptural dharma.',
  making_process = 'Block quarry select, rough split, point chisel, tooth chisel, flat chisel, rasp, polish with water and oxides.',
  materials = 'Grey granite, black granite, soapstone, tungsten-tipped tools, pneumatic hammers.',
  motifs_and_style = 'Ganesha, Buddha, Anantasayana, yali balustrades, custom portrait busts.',
  care_and_authenticity = 'Structural icons need sthapati certificate; hairline checks in cheap soapstone imports.',
  best_buying_season = 'November–February; cooler stone work weather.',
  updated_at = now()
WHERE slug = 'stone-carving-mahabalipuram';

UPDATE public.craft_hubs SET
  short_description = 'Bankura–Bishnupur terracotta: hand-built horses, elephants, and narrative plaques—fired clay echoing Malla-era temple terracotta ornament.',
  about_place_and_craft = 'Panchmura village famous for horse; Bishnupur town for miniatures. Clay from local river beds; pit or kiln firing.',
  history = 'Malla dynasty temple craft continuity; craft fairs and urban gardening markets revived demand.',
  cultural_significance = 'Bankura horses and plaques still leave kilns for folk shrines, seasonal fairs, and urban décor—terracotta continuity from Malla temple art to Bengali sacred and festive space.',
  making_process = 'Knead clay, coil or press mould, carve detail, air dry, smoke fire or kiln, apply oxide slip.',
  materials = 'Alluvial clay, iron slip for red, rice husk temper, open firing.',
  motifs_and_style = 'Bankura horse stance, elephant with howdah, Ramayana frieze plaques.',
  care_and_authenticity = 'Hollow sound if well fired; cracks on thin legs indicate poor firing; buy from WB emporia for consistency.',
  best_buying_season = 'November–February; Poush Mela stock.',
  updated_at = now()
WHERE slug = 'terracotta-bishnupur';

UPDATE public.craft_hubs SET
  short_description = 'Bengal dokra: Bikna and surrounding lost-wax brass—slender tribal figurines, musicians, and ritual lamps with fine wire texture surface.',
  about_place_and_craft = 'Smaller, often more delicate than Bastar cousins; supply Kolkata galleries and craft melas. Some workshops mix bell metal for brighter tone.',
  history = 'Migration and trade links with central Indian dokra; national awards to Bikna artists.',
  cultural_significance = 'Musicians, mother-and-child, and ritual lamps cast here serve Santhal rites and urban collectors—Bengal dokra widens eastern India''s ritual metal vocabulary.',
  making_process = 'Same lost-wax sequence as dhokra; finer wax threads for detail; patina with tamarind wash.',
  materials = 'Brass scrap, beeswax, clay, charcoal furnace.',
  motifs_and_style = 'Drummers, mother–child, horse rider, oil lamps with bird finials.',
  care_and_authenticity = 'Biswa Bangla tags; weight and casting flash marks tell hand work.',
  best_buying_season = 'October–February.',
  updated_at = now()
WHERE slug = 'dokra-bengal';

UPDATE public.craft_hubs SET
  short_description = 'Banaras gulabi meenakari: pink-leaning enamel on chased gold or silver—bridal sets, paan boxes, and vark-thin gold foil work in Vishwanath gali workshops.',
  about_place_and_craft = 'Hindu and Muslim meenakar families collaborate; firing in small pit or electric kiln. Export to Middle East and diaspora weddings.',
  history = 'Mughal enamel lineage; modern hallmarking; competition from Jaipur meena.',
  cultural_significance = 'Bridal sets and enamel paan boxes belong to Kashi''s wedding economy and Vishwanath-area goldsmith lanes—North Indian shaadi grammar in pink meena and chased metal.',
  making_process = 'Metal chase relief, fill enamel cells, fire layer by layer, polish with agate.',
  materials = 'Gold, silver, copper bases, enamel frits, chasing tools.',
  motifs_and_style = 'Rose pink fields, white parrots, peacock, minakari flowers on dark blue.',
  care_and_authenticity = 'Hallmark on precious metal; enamel should not flake on bend; price reflects gold weight not just enamel.',
  best_buying_season = 'October–March; wedding season Akshaya Tritiya spike.',
  updated_at = now()
WHERE slug = 'banaras-gulabi-meenakari';

UPDATE public.craft_hubs SET
  short_description = 'Naga bamboo and cane: split-weave baskets, mats, shields, and contemporary lighting from forest bamboo—each tribe varies twill and dye.',
  about_place_and_craft = 'Kohima, Dimapur, and village craftspeople supply Hornbill stalls; smoking bamboo darkens fibre. Cane (rattan) for load-bearing handles.',
  history = 'Headhunting-era shield weaving morphed into décor; Nagaland Bamboo Mission training centres.',
  cultural_significance = 'Weaves serve Naga village harvest storage, church and community feasts, and Hornbill stalls; neighboring Hindu homes use the same baskets for festival prep and grain—Northeast forest-to-home continuity.',
  making_process = 'Season bamboo, split to uniform width, weave twill or hex, lash with cane, edge bind, smoke optional.',
  materials = 'Dendrocalamus species, rattan cane, natural dyes, plant thread.',
  motifs_and_style = 'Geometric colour bands, hornbill feather motifs in tourist pieces, utilitarian backpack baskets.',
  care_and_authenticity = 'Even tension, no splinter splits; insect treatment essential—ask if boron treated.',
  best_buying_season = 'September–February; Hornbill Festival December.',
  updated_at = now()
WHERE slug = 'naga-bamboo-craft';

UPDATE public.craft_hubs SET
  short_description = 'Tholu bommalata: translucent goat leather puppets—perforated, painted both sides, jointed for shadow play—Nimmalakunta cluster supplies Andhra and Telugu diaspora troupes.',
  about_place_and_craft = 'Leather soaked, stretched, cured, traced, cut, painted with mineral colours, mounted on bamboo sticks. Episodes span Ramayana and local jataka-style tales.',
  history = 'Maratha-era patronage in Telugu belt; parallel to Karnataka thogalu gombeyaata; UNESCO puppet ICH context.',
  cultural_significance = 'Translucent leather puppets perform Ramayana and local tales on temple veedhis and jatra nights—Andhra''s shadow theatre keeping epic narrative inside festival time.',
  making_process = 'Dehair hide, stretch frame, thin to translucency, draw, perforate decorative holes, paint, joint limbs with rivets.',
  materials = 'Goat leather, tamarind seed black, mineral reds and yellows, bamboo, twine.',
  motifs_and_style = 'Tall Rama–Sita profiles, Hanuman with tail articulation, ornate crowns and jewellery.',
  care_and_authenticity = 'Hold to light for even thinness; hand painting vs poster print; AP Lepakshi retail.',
  best_buying_season = 'October–February; Dasara and Sankranti puppet demand.',
  updated_at = now()
WHERE slug = 'tholu-bommalata-craft';

UPDATE public.craft_hubs SET
  short_description = 'Molela murtis: flat terracotta relief plaques of Dharamraj, Gora-Badal, local heroes, and syncretic deities—unfired colour wash on low-fire clay for village shrines.',
  about_place_and_craft = 'Potters along Banas river serve Bhil and Garasia devotees who carry plaques on pilgrimage; some pieces stay sun-dried for annual replacement ritual.',
  history = 'Medieval Mewar pilgrimage economy; documented by anthropologists; contemporary gallery white-clay variants.',
  cultural_significance = 'Flat clay plaques travel with Bhil and Garasia pilgrims and sit in village devi sthanas—affordable, cyclically replaced murtis on the Rajasthan–Gujarat Aravalli belt.',
  making_process = 'Slab roll, relief model while wet, incise detail, dry, low smoke firing, apply geru and white chalk slip.',
  materials = 'Local clay, geru red slip, chalk white, open clamp kiln.',
  motifs_and_style = 'Horse riders, narrative rows, sun face, mother goddess.',
  care_and_authenticity = 'Fragile—meant for ritual cycling not heirloom durability; support large plaques flat.',
  best_buying_season = 'November–March; post-harvest fair circuits.',
  updated_at = now()
WHERE slug = 'molela-terracotta';

UPDATE public.craft_hubs SET
  short_description = 'Sikki grass golden craft: coiled golden grass (sikki) stitched with munj thread into boxes, deity caps, and fine figurines—Madhubani-area women''s micro-sculpture.',
  about_place_and_craft = 'Harvested monsoon grass turns golden when dried; coil-and-whip stitch builds rigid hollow forms without mould. UNESCO and design labs feature sikki for sustainability.',
  history = 'Household craft alongside Madhubani painting; Japan Foundation workshops; export to European museum shops.',
  cultural_significance = 'Soop, rings, and deity caps appear in Mithila weddings and vrata trays; golden grass coiling is women''s ritual craft as well as livelihood.',
  making_process = 'Split and soften sikki, coil base, pierce and stitch with needle, build walls, add dyed grass accents.',
  materials = 'Sikki grass, munj fibre, sometimes synthetic dye for contrast stripes.',
  motifs_and_style = 'Elephant, fish, pandanus geometry, lidded treasure boxes.',
  care_and_authenticity = 'Tight even stitching; natural gold tone vs painted straw; keep dry—mildew risk.',
  best_buying_season = 'October–February after grass harvest processed.',
  updated_at = now()
WHERE slug = 'sikki-grass-craft';

UPDATE public.craft_hubs SET
  short_description = 'Tripura bamboo craft: split bamboo mats, baskets, fish traps, and furniture from matriclan-based weaving groups—Cane and Bamboo Technology Institute linkage.',
  about_place_and_craft = 'Agartala emporia and village cooperatives; Tripuri, Reang, and Jamatia designs vary in rim finish and dye. Bamboo Mission adds preservative treatment.',
  history = 'Royal Tripura court utility; post-merger Indian welfare schemes; Bangladesh border ecology affects raw material.',
  cultural_significance = 'Mats, traps, and furniture support Tripuri, Reang, and Jamatia households for daily use, bazaar trade, and seasonal fairs—Tripura Bamboo Mission links forest bamboo to India''s Northeast craft economy.',
  making_process = 'Split culm, plane strips, weave plain or twill, bend frames, lash joints, smoke polish.',
  materials = 'Muli bamboo, wathwi cane, jute binding, natural black from fermentation.',
  motifs_and_style = 'Hexagonal open weave, double-walled baskets, room dividers, lamp shades.',
  care_and_authenticity = 'Tripura Bamboo Mission stamp; check for borer holes; uniform strip width signals skill.',
  best_buying_season = 'September–February; dry season for harvesting and travel.',
  updated_at = now()
WHERE slug = 'bamboo-boat-craft';
