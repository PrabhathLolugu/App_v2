-- Rich narrative content for Indian fabric hubs (fabric_hubs table).
-- Does NOT touch cover_image_url, gallery_urls, id, slug, name, region, state,
-- latitude, longitude, fabric_name, discussion_site_id, sort_order, or is_published.

UPDATE public.fabric_hubs SET
  short_description = 'Kanchipuram (Kanjeevaram) silk: dense mulberry body, contrasting korvai borders woven separately and interlocked, and zari that can approach half the saree''s weight in bridal grades.',
  about_place_and_fabric = 'Kanchipuram in Tamil Nadu is a temple town whose weaving streets (pettais) have supplied South India''s most prestigious silk drapes for generations. Genuine pieces use high-twist mulberry silk for warp and weft; borders and pallu are often woven in korvai technique—technically two three-shuttle structures joined on the loom—yielding sharp colour breaks that never look printed. Zari may be pure silver electroplated with gold (tested) or high-quality composition thread; weight and burnish distinguish occasion wear from lighter daily silks. The cluster includes master weavers, yarn dyers, and jari workers in a tight geographic ecosystem.',
  history = 'Weaving in Kanchi is traditionally linked to patronage from Chola, Vijayanagara, and later local temple trusts; migration of Telugu-speaking weaving communities enriched technique and design vocabulary. Colonial and post-independence demand, GI registration (2005–2006), and bridal economics scaled production while also spurring machine-made imitations from elsewhere—making provenance and weave inspection essential.',
  cultural_significance = 'Kanchipuram silk marks life-cycle rituals—weddings, gruhapravesam, major festivals—and often sits in family vaults as heirloom. It signals respect for tradition in diaspora communities and anchors Tamil Nadu''s handloom identity alongside temple architecture and classical arts.',
  weaving_process = 'Yarn is degummed, dyed in vats, and sized. Pit or frame looms use the korvai attachment for fixed borders; pallu may use a separate petni warp. Three-shuttle weaving, temple (triangular) devices for extra warp, and meticulous zari tensioning require synchronized teams. Finishing includes knotting loose threads and quality grading by weight, zari ratio, and defect checks.',
  motifs_and_design = 'Classic motifs include rudraksha beads, annapakshi (conjoined birds), yazhi, temple gopuram rows, checks (kattam), and broad zari bands. Body colours range from canonical kumkum red and mayil kazhuthu green to contemporary pastels; contrast borders remain the visual signature.',
  care_and_authenticity = 'Store folded with muslin, refold periodically to avoid zari crease lines; dry-clean for heavy zari. Authenticity: GI tag when present, handloom mark, reverse-side neat floats, korvai join visible at border-body junction, and purchase from TNHDC/Co-optex or documented weaver societies. Be wary of powerloom Kanchi-lookalikes sold at implausible prices.',
  best_buying_season = 'October–February for comfortable travel and wedding-season stocks; year-round in Kanchipuram with peak variety before Tamil wedding months. Monsoon demands careful storage if buying unstitched lengths.',
  updated_at = now()
WHERE slug = 'kanchipuram-silk';

UPDATE public.fabric_hubs SET
  short_description = 'Banarasi brocade: silk ground with kadwa (cutwork) or asarfi jari butis, often on jacquard-assisted pit looms—Varanasi''s answer to courtly brocade and modern bridal opulence.',
  about_place_and_fabric = 'Varanasi (Benares) sits at the Ganges heart of North Indian pilgrimage and trade; its weavers historically supplied courts and merchants with silk brocades, kinari borders, and yardage. Today the cluster spans silk, organza, georgette bases with brocade add-ons, and classic katan (pure silk) sarees. Techniques include kadwa (each motif woven separately, heavier but crisp), fekwa (continuous extra weft, lighter), and jangla all-over jaal. The reverse often shows neat extra-weft floats—hallmarks of hand skill versus printed imitations.',
  history = 'Medieval and Mughal-era patronage fused Persian floral geometry with Indian lotus and bel (vine) layouts; Maratha and Awadh elites sustained demand. Post-independence powerlooms in Surat and elsewhere challenged pure handloom share, leading to GI status for Banaras brocade/silk (2009) and ongoing debates about hybrid mechanization.',
  cultural_significance = 'Banarasi remains the default north Indian bridal aspiration, layered with red ritual symbolism and family gifting economies. It represents Uttar Pradesh''s craft prestige globally and appears in cinema, weddings, and state emporia narratives.',
  weaving_process = 'Warping and drafting set repeat lengths; jacquard cards or electronic jacquard define motif lifts. Weft may include gold- or silver-toned jari; dyeing must be fast to survive multiple passes. Finishing includes cutting floats on kadwa pieces, steaming, and mounting for retail.',
  motifs_and_design = 'Kalga-bel (arching floral sprays), jangla meanders, asarfi (coin-like) butis, shikargah hunting scenes in fine pieces, and intricate pallu panels. Colour palettes span classic katan reds and maroons to pastel bridal markets.',
  care_and_authenticity = 'Dry-clean; avoid folding on heavy zari creases. Check GI handloom labels, Development Commissioner (Handlooms) schemes, reverse-side structure, and weight versus claimed “pure” silk. Banaras lookalikes from powerloom hubs are common—price and weave inspection matter.',
  best_buying_season = 'November–March for weather and wedding fairs; Dev Deepawali and wedding seasons see peak retail energy in the old city.',
  updated_at = now()
WHERE slug = 'banarasi-silk';

UPDATE public.fabric_hubs SET
  short_description = 'Bhagalpuri (Tussar) silk: wild Antheraea mylitta and related silks with natural gold-beige tones, slubbed texture, and breathable drape from Bihar''s river-plain sericulture belt.',
  about_place_and_fabric = 'Bhagalpur''s cluster integrates forest-based and farm-based tussar cocoon rearing with reeling, spinning, dyeing, and handloom/powerloom weaving across town and surrounding districts. Tussar''s shorter staple than mulberry yields a more textured yarn; eri and mulberry variants are also traded here. Fabrics suit sarees, stoles, menswear, and export-oriented natural-dye lines. The “Bhagalpuri silk” name has faced adulteration in open markets, so fiber testing and trusted channels matter.',
  history = 'The Ganges-side town long participated in eastern India''s silk trade; cooperative and government sericulture extension scaled tussar after independence. Recent decades brought competition from synthetic lookalikes and decentralized production, while designers revived tussar for sustainable fashion narratives.',
  cultural_significance = 'Tussar connects Bihar and Jharkhand''s tribal and farming communities to urban wardrobes; it carries an earthy, understated aesthetic compared to high-gloss mulberry bridal silks.',
  weaving_process = 'Cocoons are boiled and reeled or spun into hanks; degumming levels adjust sheen. Dyeing may use natural or reactive dyes; looms produce varied counts from coarse home textiles to fine saree widths. Blends with cotton or synthetic for price points exist—label reading is essential.',
  motifs_and_design = 'Plain and twill bodies with woven or printed stripes, tribal-inspired geometries when marketed from partner clusters, and minimalist borders dominate; printed Kalamkari-style overlays appear in contemporary lines.',
  care_and_authenticity = 'Gentle hand wash for many tussars unless zari is present; verify silk percentage and Bihar state emporia or certified cooperatives. Microscope burn tests and seller documentation help distinguish pure tussar from “art silk.”',
  best_buying_season = 'September–February; post-harvest periods align with cocoon availability and trade fairs.',
  updated_at = now()
WHERE slug = 'bhagalpur-tussar';

UPDATE public.fabric_hubs SET
  short_description = 'Pochampally double ikat: resist-dyed warp and weft aligned on the loom for crisp geometric fields—Telangana''s GI-protected ikat alongside cotton-silk and mercerized cotton lines.',
  about_place_and_fabric = 'Pochampally and nearby villages (part of a larger Yadadri Bhuvanagiri cluster) specialize in tying yarn bundles before dyeing, then weaving so that pre-planned colour blocks form diamonds, squares, and temple steps. Single-ikat (warp or weft only) pieces are common and more affordable than double ikat. The visual “feathered” edge inside motifs indicates hand tying versus printed ikat-look fabrics.',
  history = 'Weavers migrated into the region in waves; cooperative organization and export push in the late twentieth century scaled markets. GI registration (2005) helped brand “Pochampally Ikat.” Competition from mill-printed imitations keeps education about true tie-dye yarn central.',
  cultural_significance = 'Ikat sarees and dress materials are everyday prestige wear in Telangana and Andhra; they also index handloom modernism in urban India.',
  weaving_process = 'Graphs guide tying; repeated dye baths build colour sequence; yarns are stretched and tension-matched on the loom. Misalignment shows as blur—master weavers adjust tension and beat. Finishing washes soften hand.',
  motifs_and_design = 'Chowk (house) patterns, diamonds, elephants, parrots in folk pieces, and contemporary abstract repeats. Palette spans indigo-ikat classics to bright fashion tones.',
  care_and_authenticity = 'Cold wash or dry-clean by fibre content; check for tie-dye yarn ends at fringe, motif clarity, and cooperative certification. Printed “Pochampally style” is widespread.',
  best_buying_season = 'October–February; Telangana tourism and handloom expos cluster in cooler months.',
  updated_at = now()
WHERE slug = 'pochampally-ikat';

UPDATE public.fabric_hubs SET
  short_description = 'Surat: India''s synthetic and blended textile powerhouse—powerloom sarees, dress materials, embroidery bases, and dye houses feeding nationwide wholesale.',
  about_place_and_fabric = 'Surat''s strength is volume, speed, and vertical integration: yarn markets, sizing, weaving, dyeing, printing, and embellishment. While not a single “heritage weave” like Patola, Surat anchors the economic reality of how most Indians access affordable occasionwear. Traditional segments include art silk sarees, jacquard yardage, and ruffle-ready georgettes; the city also hosts handloom-adjacent curations in state emporia.',
  history = 'Mughal-era port prestige gave way to colonial cotton shifts, then post-independence synthetic revolution (polyester, rayon blends). Surat became synonymous with petrochemical-textile innovation and migrant labour economies.',
  cultural_significance = 'Surat cloth reaches every state through wholesalers; it shapes festival dressing for middle India and supplies garment export hubs.',
  weaving_process = 'High-speed powerlooms, automatic jacquard, and roller printing dominate; design cycles follow Bollywood and seasonal colour forecasts. Quality tiers range from commodity to export-grade inspection lots.',
  motifs_and_design = 'Jacquard butis, ombre dyeing, foil work, and embroidery-ready grounds. “Traditional” Surat often means visual mimicry of Banarasi or South silk at accessible price.',
  care_and_authenticity = 'Read fiber labels; many products are blended. For verified handloom segments, use government emporia. Surat value is consistency and price—verify fire-retardant claims and dye fastness for children''s wear.',
  best_buying_season = 'October–March; avoid monsoon logistics for bulk buying. Textile expos run year-round.',
  updated_at = now()
WHERE slug = 'surat-textiles';

UPDATE public.fabric_hubs SET
  short_description = 'Chanderi: fine silk-cotton and pure silk with translucent body, ashrafi butis, and gold lotus borders—Madhya Pradesh''s airy weave between Gwalior and Malwa.',
  about_place_and_fabric = 'Chanderi town produces sarees and yardage whose hallmark is gauzy transparency from fine counts and single-flange tensioning. Traditional motifs include gold dots (ashrafi), eent (brick), and floral bootis. Silk-by-cotton (SICO) balances durability with sheen; pure silk variants suit heavier occasions. The cluster benefited from GI tag (Chanderi saree) and designer collaborations.',
  history = 'Royal patronage from local states and proximity to trade routes sustained weaving through medieval periods; 20th-century decline and 21st-century revival via cooperatives and fashion weeks reframed Chanderi as premium handloom.',
  cultural_significance = 'Chanderi is preferred for summer weddings, office ethnic wear, and lightweight festive drape across central India.',
  weaving_process = 'Fine yarn preparation, sizing with natural adhesives, and pit/frame loom weaving with extra warp for butis. Some butis use needles (as in Jamdani lineage influences) for supplementary weft inlay on selected lines.',
  motifs_and_design = 'Ashrafi buti, meena work (coloured outline on butis), peacocks, traditional borders with narrow zari, and contemporary minimalist fields.',
  care_and_authenticity = 'Dry-clean for zari; store away from snags. Check GI labels, yarn fineness, and even transparency against held light. Powerloom Chanderi-look sheers exist.',
  best_buying_season = 'November–February; festivals like Diwali drive retail peaks in MP emporia.',
  updated_at = now()
WHERE slug = 'chanderi-weave';

UPDATE public.fabric_hubs SET
  short_description = 'Maheshwari: reversible silk-cotton sarees with geometric borders inspired by Narmada ghats—Maheshwar''s crisp checks, stripes, and bugdi (small dot) motifs.',
  about_place_and_fabric = 'Maheshwar on the Narmada was revived as a weaving centre under Rehwa Society and allied initiatives linked to the Holkar legacy. Sarees feature light body, contrasting border on both faces (reversible wear), and often five stripes evoking fort architecture. Cotton, silk-cotton, and pure silk grades exist; pallus carry distinctive patterns like chattai (mat) or eent.',
  history = 'Queen Ahilyabai Holkar-era patronage is foundational in popular narrative; mid-twentieth-century decline gave way to cooperative revival models that trained women weavers and standardized quality.',
  cultural_significance = 'Maheshwari bridges daily and festive use—professional women often favour it for weight and elegance; it anchors Madhya Pradesh craft tourism.',
  weaving_process = 'Yarn dyeing, border-first planning on loom, and careful tension for reversible edges. Some lines use jacquard for pallu complexity; finishing emphasizes even selvedges.',
  motifs_and_design = 'Bugdi, leher (waves), chattai, geometric stripes in maroon-black-gold classic palettes; contemporary pastels for urban markets.',
  care_and_authenticity = 'Buy from Rehwa Society outlets or documented cooperatives; hand feel should be crisp not plastic-coated. Store folded with tissue along zari.',
  best_buying_season = 'September–February; Narmada pilgrimage seasons overlap with craft sales.',
  updated_at = now()
WHERE slug = 'maheshwari-weave';

UPDATE public.fabric_hubs SET
  short_description = 'Patan Patola: double ikat silk where warp and weft are resist-dyed before weaving—months of tying for one saree, among India''s rarest textiles.',
  about_place_and_fabric = 'Only a few families in Patan (Gujarat) traditionally mastered the full vertical stack of design, tying, dyeing, and weaving for patola. Both sets of threads must meet at perfect intersections; error is cumulative. The result is identical front and back. Single-ikat Rajkot patola is related but less laborious. Authentic patola commands luxury prices reflecting labour months per piece.',
  history = 'Jain and merchant patronage, Solanki-era prestige, and migration narratives (Salvi community) frame patola history. GI recognition and museum acquisitions increased global awareness; copying attempts are common but lack structural precision.',
  cultural_significance = 'Patola is heirloom and status cloth in Gujarat and among diaspora; wedding rituals sometimes specify “real” patola as dowry prestige.',
  weaving_process = 'Graph-based tying on skeins, sequential dye baths (ikat sequence is irreversible if wrong), realignment on loom, and slow weaving with constant verification. Natural dyes appear in heritage lines; some contemporary work uses fast synthetic palettes.',
  motifs_and_design = 'Narikunjar (composite elephant), popat (parrot), nari kunj, geometric chhabdi bhat (basket), and kaleidoscopic pallu layouts in classic red-white-black-indigo families.',
  care_and_authenticity = 'Never machine wash; museum-grade storage for heirlooms. Purchase only from documented Salvi workshops with provenance; expect certificates and price commensurate with months of work. Mass-market “patola print” is unrelated.',
  best_buying_season = 'October–March; Rann Utsav tourism can align with Patan visits.',
  updated_at = now()
WHERE slug = 'patan-patola';

UPDATE public.fabric_hubs SET
  short_description = 'Paithani: Maharashtrian silk with kaleidoscopic peacock and lotus pallus, often with oblique border technique—Yeola is today''s volume hub beside Paithan.',
  about_place_and_fabric = 'Paithani uses rich silk with contrasting borders woven obliquely (kadiyal-style adaptation) so body and border colours stay pure without mixing. Pallus display parinda (peacock), mor (peacock feather fan), and lotus asawali vines. Yeola (near Shirdi) concentrates powerloom and handloom production; discerning buyers still seek verified handloom with traditional zari.',
  history = 'Satavahana-era associations appear in promotional literature; documented boom is medieval Deccan trade and Maratha courtly dress. Twentieth-century decline and revival parallel other silks; film and wedding industries drive demand.',
  cultural_significance = 'Paithani is iconic at Marathi weddings and Ganesh/Utsav dressing; green peacock pallus are especially sought.',
  weaving_process = 'Silk dyeing, border planning with kadiyal, brocade pallu weaving with jari weft, and meticulous finishing. Handloom pieces show more irregular “life” than tight powerloom copies.',
  motifs_and_design = 'Peacock pairs, lotus panels, ajanta-inspired vines, and narali (coconut) borders in traditional pieces.',
  care_and_authenticity = 'Avoid moisture and plastic storage; silica for monsoon. Verify silk and zari quality; Maharashtra state outlets and reputed Yeola workshops help. Beware lightweight powerloom imitations.',
  best_buying_season = 'October–February; wedding season (Akshaya Tritiya to winter) peaks sales.',
  updated_at = now()
WHERE slug = 'paithani-yeola';

UPDATE public.fabric_hubs SET
  short_description = 'Sambalpuri Bandha: Odisha''s tie-dye yarn ikat with bold geometry and symbolic motifs—Sambalpur, Bargarh, and Sonpur clusters.',
  about_place_and_fabric = 'Bandha (Odia for tied) follows resist on yarn before weaving, producing mirror-sharp motifs when executed well. Cotton dominates everyday wear; silk bandha serves rituals and state occasions. The craft encodes Odia identity alongside Gotipua dance and temple architecture. GI recognition covers “Sambalpuri Ikat.”',
  history = 'Weaver-service communities (Meher) and cooperative movements scaled production; political and cultural revivalism in late twentieth century made bandha a symbol of Odisha pride.',
  cultural_significance = 'Worn in Nuakhai harvest, Kumar Purnima, and political gatherings as visible regional dress; also standardized for Odisha tableau and official delegations.',
  weaving_process = 'Tying to graph, multi-bath dyeing, loom alignment, and weaving with careful beat. Natural dye bandhas exist in niche ateliers.',
  motifs_and_design = 'Shankha (conch), chakra (wheel), fish, elephant, pasapalli (chessboard), and temple borders.',
  care_and_authenticity = 'Boyanika and government emporia provide certification paths; check motif edges for true ikat blur-versus-sharp patterning vs print.',
  best_buying_season = 'October–February; post-monsoon craft melas.',
  updated_at = now()
WHERE slug = 'sambalpuri-ikat';

UPDATE public.fabric_hubs SET
  short_description = 'Baluchari: narrative silk sarees from Bishnupur with jacquard-woven mythological panels on pallu—Bengal''s figurative brocade cousin to Swarnachari (zari figuration).',
  about_place_and_fabric = 'Bishnupur''s Malla-era temple legacy intersects with eighteenth-nineteenth century Baluchari imports inspiration; local weavers adapted figural brocade to silk. Pallus depict Ramayana/Mahabharata scenes, nawabi leisure, or contemporary miniatures in revived lines. Jacquard mechanisms reduce labour versus pure hand-picked brocade but still require design coding and silk quality.',
  history = 'Decline under British industrial competition nearly extinguished the craft; post-independence revival by artisans and designers restored narrative panels, with Swarnachari adding more zari figuration.',
  cultural_significance = 'Baluchari is exhibition and wedding wear—conversation pieces in Bengal''s handloom hierarchy alongside Jamdani.',
  weaving_process = 'Silk warping, jacquard card or electronic programming, multi-shuttle brocade weaving, and careful washing/setting to protect floats.',
  motifs_and_design = 'Figural pallu friezes, kalka (paisley) borders, floral meanders, and architectural arches echoing terracotta temple lines.',
  care_and_authenticity = 'Dry-clean; roll storage for heavy pieces. Buy from state emporia or documented weavers; inspect reverse for brocade structure and narrative clarity.',
  best_buying_season = 'November–February; winter wedding season in eastern India.',
  updated_at = now()
WHERE slug = 'baluchari-bishnupur';

UPDATE public.fabric_hubs SET
  short_description = 'Muga silk: golden wild silk endemic to Assam''s Brahmaputra valley—natural sheen, durability, and status fibre alongside eri (ahimsa) and pat (mulberry).',
  about_place_and_fabric = 'Sualkuchi (“Manchester of Assam”) concentrates weavers working muga, eri, and pat. Muga comes from Antheraea assamensis; its natural gold tone deepens with wear. Strictly regulated production and high cost reflect ecological limits and rearing skill. Sarees, mekhela chador sets, and stoles dominate output.',
  history = 'Ahom-era patronage and trade with hill communities structured sericulture; colonial documentation noted muga''s uniqueness. Today climate stress and authentication battles against blended “muga look” products challenge the sector.',
  cultural_significance = 'Muga is prestige dress for Bihu, weddings, and state hospitality; it encodes Assamese identity comparable to tea and Bihu music.',
  weaving_process = 'Cocoon cooking, reeling, twist setting, dyeing (often minimal to preserve gold), and fly-shuttle loom weaving with traditional motifs.',
  motifs_and_design = 'Goja (tree of life), geometric jaal, traditional buta, and contemporary minimalist bodies with muga-highlight borders.',
  care_and_authenticity = 'Assam Apex cooperatives and certified dealers; microscopic silk identification when in doubt. Avoid harsh detergents; store with moth protection.',
  best_buying_season = 'October–March; Rongali Bihu (April) prep begins earlier in weaving calendar.',
  updated_at = now()
WHERE slug = 'muga-silk-sualkuchi';

UPDATE public.fabric_hubs SET
  short_description = 'Jamdani: muslin-family cotton (or silk) with discontinuous extra-weft inlay—once Mughal finery, now Bengal and Bangladesh heritage with UNESCO recognition.',
  about_place_and_fabric = 'Nadia district and wider Bengal basin host weavers inserting ornamental weft with spools or needles while ground cloth advances—no jacquard. Fine counts yield sheer “woven air”; motif appears to float. Cotton jamdani suits humid climates; silk-tissue variants serve luxury markets. Revival projects train youth against aging artisan demographics.',
  history = 'Dhaka jamdani was legendary; partition shifted clusters; export bans and revival schemes oscillated. UNESCO inscribed jamdani weaving (Bangladesh) as ICH, boosting parallel Indian narratives.',
  cultural_significance = 'Jamdani sarees mark refined taste in Bengal; political leaders often wear white jamdani on formal occasions.',
  weaving_process = 'Fine yarn spinning, sizing, ground weaving with simultaneous inlay by second operator on complex pieces, and delicate washing.',
  motifs_and_design = 'Tercha (diagonal floral), panna hajar (thousand emeralds), jhalar, lotus, and contemporary abstract inlay.',
  care_and_authenticity = 'Hand wash delicate cottons; professional clean for silk. Biswa Bangla and documented NGOs help; inspect motif as woven floats, not print.',
  best_buying_season = 'October–February; Poila Boishakh (April) drives spring buying.',
  updated_at = now()
WHERE slug = 'jamdani-nadia';

UPDATE public.fabric_hubs SET
  short_description = 'Kota Doria: square-checked kota-masuria weave—cotton-silk or pure cotton open mesh ideal for hot climates, from Kota and nearby Kaithoon.',
  about_place_and_fabric = 'The distinctive khat (check) comes from alternating tension groups in warp and weft creating a graph-paper transparency. Traditional onion-garlic sizing gave crisp hand; modern variants adjust fiber mix. Sarees, dupattas, and yardage serve Rajasthan and pan-Indian summer wardrobes. Real kota doria is handloom; powerloom mesh imitations abound.',
  history = 'Legend links Mysore migrants to Rao Kishore Singh''s eighteenth-century patronage naming “Kota-Masuria”; GI tag (Kota Doria) protects naming for handloom.',
  cultural_significance = 'Bridal odhnis in Rajasthan often use kota; urban India adopts it for office and festival lightness.',
  weaving_process = 'Pit loom, reed planning for khat grid, cotton-silk blending at yarn stage, and post-weave washing to set openness.',
  motifs_and_design = 'Plain khat, zari-bordered khat, chashm-e-bulbul (eyelet) variants, and printed kota for fashion tiers.',
  care_and_authenticity = 'Gentle wash; avoid snagging on jewelry. Kota Doria Development Society and GI handloom marks help verify; price-too-low mesh is often powerloom.',
  best_buying_season = 'September–March; summer weddings favour lightweight stock in April–June retail.',
  updated_at = now()
WHERE slug = 'kota-doria';

UPDATE public.fabric_hubs SET
  short_description = 'Venkatagiri: fine cotton and silk-cotton handloom sarees with jamdani-style butis—Nellore district''s soft drape tradition.',
  about_place_and_fabric = 'Venkatagiri weavers produce lightweight sarees prized for all-day comfort; zari borders stay relatively narrow compared to Kanjeevaram. Silk-cotton mixes and pure cotton dominate; “Venkatagiri silk” usually means finer counts with silk highlight. The town name signals historic zamindar patronage.',
  history = 'Nayaka and later British-era patronage supported fine counts; competition from mills and powerlooms pushed cooperatives to emphasize quality niches.',
  cultural_significance = 'Popular for Andhra Pradesh office wear, temple visits, and understated gifting; contrasts with heavier Dharmavaram or Kanchipuram in the same macro-region.',
  weaving_process = 'Fine warp preparation, buti insertion via extra weft or small jacquard in some lines, and careful sizing removal for soft hand.',
  motifs_and_design = 'Small butis (dots, flowers), simple borders, and pastel fields; occasional tested zari.',
  care_and_authenticity = 'AP handloom cooperatives; feel for evenness and absence of polyester shine. Handloom marks and price realism guide buyers.',
  best_buying_season = 'October–February.',
  updated_at = now()
WHERE slug = 'venkatagiri-saree';

UPDATE public.fabric_hubs SET
  short_description = 'Uppada Jamdani: Andhra''s fine silk with extra-weft jamdani inlay—soft hand, floating motifs, and coastal weaving cluster east of Kakinada.',
  about_place_and_fabric = 'Uppada sarees merge mulberry silk ground with discontinuous weft patterning inspired by Bengal jamdani technique, adapted to local silk supply chains. The weave aims for lightness unlike heavy kanjeevaram; motif clarity and drape are selling points. Cooperative organization helps weavers access fairs and e-commerce.',
  history = 'Late twentieth-century skill transfer and marketing created “Uppada Jamdani” as a distinct brand; earlier generic fine silk weaving existed in the region.',
  cultural_significance = 'Bridal and reception wear in Andhra–Telangana markets; diaspora weddings showcase it as regional alternative to Banarasi weight.',
  weaving_process = 'Silk reeling and dyeing, ground weaving on pit/frame loom, inlay work with secondary shuttles or needle, finishing wash.',
  motifs_and_design = 'Floral jhalar, geometric repeats, peacock rows, and contemporary minimalist fields.',
  care_and_authenticity = 'Dry-clean; inspect reverse for inlay floats. Cooperative sales centres reduce adulteration risk.',
  best_buying_season = 'October–February.',
  updated_at = now()
WHERE slug = 'uppada-jamdani';

UPDATE public.fabric_hubs SET
  short_description = 'Dharmavaram silk: broad solid or lightly figured body with heavy contrast border and pallu—bridal grandeur from Anantapur district, Andhra Pradesh.',
  about_place_and_fabric = 'Dharmavaram sarees emphasize wide zari borders and rich pallus, often in jewel tones with tested zari. Weaving households and small workshops supply South Indian wedding markets; some lines approach Kanjeevaram visually but use different border construction traditions. Durability and weight are higher than Venkatagiri.',
  history = 'Local patronage and silk trade routes through Rayalaseema supported growth; recent decades saw branding as “Dharmavaram pattu” in wedding retail.',
  cultural_significance = 'Major bridal option in Andhra Pradesh and neighbouring states; featured in wedding photography and gold-jewellery pairings.',
  weaving_process = 'Silk doubling, dye vats, border loom setups similar to korvai-class techniques in some pieces, zari weft brocade on pallu, finishing stretch and steam.',
  motifs_and_design = 'Temple borders, annapakshi, checks, and large pallu zari fields; contrast colour blocking.',
  care_and_authenticity = 'State emporia and known retailers; check zari burnish versus plastic shine; weight should match silk content claims.',
  best_buying_season = 'October–February; Ugadi–wedding season peaks.',
  updated_at = now()
WHERE slug = 'dharmavaram-silk';

UPDATE public.fabric_hubs SET
  short_description = 'Mysore silk: Karnataka Silk Industries Corporation–style mulberry silk with factory-finished consistency—sarees known for pure colour fields and restrained zari.',
  about_place_and_fabric = 'Mysuru''s KSIC showrooms retail sarees woven under state-sector quality control: degummed mulberry silk, standardized dye lots, and hallmarking schemes. Unlike village handloom variance, Mysore silk markets uniformity and trust. Private looms also produce “Mysore silk” labeled products—buyer should verify KSIC versus generic.',
  history = 'Maharaja patronage and twentieth-century industrial sericulture integration made Mysore a silk capital; KSIC (1912 lineage) institutionalized the brand.',
  cultural_significance = 'Default high-trust gifting silk in Karnataka; graduation and workplace milestones often celebrated with a Mysore silk saree.',
  weaving_process = 'Powerloom and handloom hybrids in sector supply chain; dye quality control, zari testing labs in institutional setup, finishing with fringe knotting.',
  motifs_and_design = 'Solid bodies with simple border-zari lines, gold-edge contrasts, occasional buttis; colour naming is part of retail culture.',
  care_and_authenticity = 'Prefer KSIC showrooms for chain-of-custody; check silk marks and invoices. Store away from perfume and moisture.',
  best_buying_season = 'October–February; Dasara season in Mysuru peaks tourism and sales.',
  updated_at = now()
WHERE slug = 'mysore-silk';

UPDATE public.fabric_hubs SET
  short_description = 'Kantha: running-stitch quilting on repurposed cloth—rural Bengal''s thrift art, now global slow-fashion and Shantiniketan studio product.',
  about_place_and_fabric = 'Traditional kantha layered old sarees with fine running stitch for warmth and decoration; motifs map daily life—lotus, fish, chariot, mythic figures. Shantiniketan''s art schools reframed kantha as narrative surface design on new cloth for urban markets. Contemporary ateliers blend embroidery density with fashion silhouettes.',
  history = 'Women''s domestic craft in undivided Bengal; revival through NGOs and design interventions since late twentieth century; UNESCO and museum exhibitions raised profile.',
  cultural_significance = 'Symbol of Bengali woman''s creativity and resilience; also post-colonial craft identity in global ethical fashion discourse.',
  weaving_process = 'Base cloth (often cotton or tussar) is layered or single; stitch direction builds relief; natural indigo and madder bases appear in heritage-style pieces.',
  motifs_and_design = 'Tree of life, solar mandala, folk narrative scenes, alphabet samplers in teaching cloths, abstract stitch fields.',
  care_and_authenticity = 'Hand wash cold; avoid pulling embroidered areas. Provenance from documented artisan groups beats anonymous tourist stalls.',
  best_buying_season = 'October–March; winter craft fairs; Poush Mela vicinity for Bolpur cluster visits.',
  updated_at = now()
WHERE slug = 'kantha-shantiniketan';

UPDATE public.fabric_hubs SET
  short_description = 'Eri silk: peace silk from castor-fed Samia ricini cocoons—matte warmth, often natural ivory or dyed, woven in Ri Bhoi and wider Meghalaya/Khasi hills.',
  about_place_and_fabric = 'Eri filaments are spun like wool after open-moth emergence (ahimsa narrative), yielding spongy, thermal drape. Ri Bhoi district clusters integrate rearers, spinners, and weavers in community value chains. Blends with cotton appear; pure eri has distinctive handle.',
  history = 'Northeast sericulture predates colonial rule; NERAMAC and state schemes scale marketing; designers promote eri as vegan-adjacent silk discourse.',
  cultural_significance = 'Everyday and ceremonial shawls in Khasi–Jaintia contexts; growing pan-Indian adoption as “ethical silk.”',
  weaving_process = 'Cocoon boiling and spinning, ply twisting, natural dye vats, backstrap or frame loom weaving with tribal geometry.',
  motifs_and_design = 'Plain weave dominant; supplementary warp patterns in some lines; contemporary shibori and stitch overlays in studio goods.',
  care_and_authenticity = 'NERAMAC partners and Meghalaya cooperative tags; burn test and vendor transparency for blends.',
  best_buying_season = 'October–March; avoid monsoon mold in humid storage when buying unstitched.',
  updated_at = now()
WHERE slug = 'eri-silk-ri-bhoi';

UPDATE public.fabric_hubs SET
  short_description = 'Kashmiri pashmina: fine Changthangi goat down hand-spun and woven on small looms in Srinagar—shawls, stoles, and “ring test” lore.',
  about_place_and_fabric = 'True pashmina uses ultra-fine undercoat fiber, often 12–16 micron, spun by hand and woven plain or embroidered (sozni needlework, papier-mâché motif inspiration, or rare kani loom-woven pattern sticks). GI “Kashmir Pashmina” specifies hand-spun, hand-woven from Ladakh/Cashmere goat fiber. Machine-spun and viscose blends flood cheap markets.',
  history = 'Mughal court prestige, French export fashion (cashmere), and nineteenth-century European demand shaped global mythos. Post-partition politics and tourism economies keep Srinagar ateliers central despite conflict disruptions.',
  cultural_significance = 'Heirloom gifting across South Asia; winter formal wear globally; symbol of Kashmiri artisan resilience.',
  weaving_process = 'Dehairing, hand spinning on charkha, sizing with rice starch, loom weaving, washing in river water traditionally, embroidery stages lasting months for fine pieces.',
  motifs_and_design = 'Butidar jaal, paisley kar pattern, hashidar borders, chinar leaves, and contemporary minimalist plains.',
  care_and_authenticity = 'GI hologram when available; extreme fineness should pass ring test loosely—not sole proof. Buy from government emporia or established houses with written fiber declaration. Moth protection and breathable storage mandatory.',
  best_buying_season = 'November–February; winter tourism aligns with shawl buying (verify ethical pricing).',
  updated_at = now()
WHERE slug = 'kashmiri-pashmina';

UPDATE public.fabric_hubs SET
  short_description = 'Kutch Ajrakh: mineral and natural-dye block print with resist—indigo, madder, and repeat geometry from Bhuj and Ajrakhpur.',
  about_place_and_fabric = 'Ajrakh uses multiple wash-resist-dye cycles on cotton (sometimes silk): harde mordanting, indigo vats, madder red, and precise registration of carved teak blocks. Khatri Muslim communities historically dominated the craft; Ajrakhpur village is a named centre. Fabric is reversible in classic pieces—pattern reads on both sides.',
  history = 'Indus valley archaeological echoes are popular in storytelling; documented trade links span Sindh and Kutch. Contemporary natural-dye revival attracts global ethical fashion.',
  cultural_significance = 'Worn as shoulder cloths, lungis, and women''s wraps in Sindh-Kutch cultures; also pan-Indian artisan chic.',
  weaving_process = 'Not weaving but full-cloth process: washing, liming, mordanting, resist printing, vat dipping, sun exposure, repeat up to twenty stages for premium yardage.',
  motifs_and_design = 'Central jaal with border friezes, star geometries, trefoil, and micro repeat; classic palette indigo-red-black-white.',
  care_and_authenticity = 'Cold wash with pH-neutral soap; fade is patina. Buy from Kutch cooperatives or named Khatri workshops; cheap “ajrakh print” is single-pass screen print.',
  best_buying_season = 'October–February; Rann Utsav tourism.',
  updated_at = now()
WHERE slug = 'kutch-ajrakh';

UPDATE public.fabric_hubs SET
  short_description = 'Balaramapuram kasavu: Kerala''s cream cotton handloom with pure zari or copper-zari borders—set mundu, veshti, and ritual white-gold aesthetic.',
  about_place_and_fabric = 'Balaramapuram near Thiruvananthapuram weaves narrow and double-width cotton for mundu-neriyathu (set mundu) and kasavu sarees. Gold-thread borders (kara) range from slim to broad “tissue” effects; some pieces use real zari sparingly. Handloom society stamps and cooperative tags are common.',
  history = 'Travancore royal patronage and temple textile demand structured the cluster; twentieth-century cooperative movement (e.g., Hantex network) organized marketing.',
  cultural_significance = 'Mandatory visual grammar for Malayali weddings, Onam, and temple visits; kasavu encodes purity and auspicious contrast.',
  weaving_process = 'Cotton yarn bleaching to off-white, starch sizing, border warp planning with zari, fly-shuttle pit loom weaving, washing and calendering.',
  motifs_and_design = 'Plain kara, peacock or temple borders in enhanced lines, mural-inspired borders in contemporary designer collaborations.',
  care_and_authenticity = 'Hantex and Kerala cooperative outlets; check handloom number; zari should not tarnish instantly—verify copper versus tested zari claims.',
  best_buying_season = 'October–February; Onam (Aug–Sep) drives peak kasavu demand—order early.',
  updated_at = now()
WHERE slug = 'balrampuram-handloom';

UPDATE public.fabric_hubs SET
  short_description = 'Ilkal saree: Karnataka''s cotton body with silk pallu (tope teni join), often with gayathri border and chikhara checks—Bagalkot district heritage.',
  about_place_and_fabric = 'The saree joins separately woven body and pallu on loom using loops (tope teni) without sewing—distinctive durability and look. Cotton-silk and full silk variants exist; traditional colours include red-black, peacock blue, and pomegranate. Ilkal serves daily, office, and festive roles in north Karnataka.',
  history = 'Chalukya-era textile links appear in promotional history; modern GI (Ilkal saree) protects geography and specs for handloom.',
  cultural_significance = 'Identity marker at Lingayat and wider Karnataka functions; younger wearers pair with contemporary blouses for fusion looks.',
  weaving_process = 'Body warp on loom, pallu woven with rayon/silk weft in contrasting shed, joining technique, border insertion with gayathri stripe.',
  motifs_and_design = 'Chikhara checks, gopura bands, rudraksha-inspired dots, and temple borders.',
  care_and_authenticity = 'Karnataka handloom outlets; verify join integrity and GI handloom tags; avoid sellers mislabeling powerloom copies.',
  best_buying_season = 'October–March.',
  updated_at = now()
WHERE slug = 'ilkal-saree';

UPDATE public.fabric_hubs SET
  short_description = 'Kullu shawl: Himalayan wool handloom with vivid border patterning—plain body, geometric ends, and cold-climate utility from the Beas valley.',
  about_place_and_fabric = 'Weavers use local sheep wool, merino blends, or imported yarn depending on price tier. Looms produce long shawl lengths with patterned border warps; body stays undyed or solid. Dussehra fair in Kullu historically concentrated sales; state emporia distribute wider.',
  history = 'Migration of shawl weavers from Bushehar and kinship networks shaped Kullu''s industry; post-independence Himachal Handloom & Handicrafts Corporation institutionalized marketing.',
  cultural_significance = 'Ceremonial gift at weddings and kinship events; visible marker of Himachali dress when paired with cap; tourist souvenir economy.',
  weaving_process = 'Yarn dyeing in bright acid colours for borders, warp dressing with pattern segments, weaving, fulling or washing for hand.',
  motifs_and_design = 'Geometric kinnauri-influenced borders, angular florals, pick-and-pick colour stripes, occasional deity motifs in tourist lines.',
  care_and_authenticity = 'Dry-clean wool; avoid moth. Himachal government sales centres help verify handloom; scratchy super-cheap pieces may be acrylic-heavy.',
  best_buying_season = 'November–February; Dussehra (October) fair for maximum variety.',
  updated_at = now()
WHERE slug = 'kullu-shawl';

UPDATE public.fabric_hubs SET
  short_description = 'Bagru block print: mud resist (dabu) and natural dyes on cotton—indigo, madder, and iron black from Jaipur district''s artisan town.',
  about_place_and_fabric = 'Chhipa families carve teak blocks and print mud-resist pastes before indigo dips or madder overdyes, producing sun-faded earth aesthetics. Bagru differs from Sanganeri in bolder layouts and community composition; both feed Jaipur''s export garment units. Yardage, dupattas, and home linen are common.',
  history = 'Rajput court and village markets sustained block printing; water quality and desert sun became part of technical ecology; contemporary organic-cert lines target export.',
  cultural_significance = 'Defines Rajasthan''s textile tourist imaginary alongside leheriya and bandhani; worn in fusion ethnic wear pan-India.',
  weaving_process = 'Scoured cotton, tannin mordant, block printing with dabu resist, drying, vat dipping, resist removal, repeat for multi-colour, final wash.',
  motifs_and_design = 'Syahi (fine floral), bold bootis, geometric repeats, and border strips; classic indigo ground with white resist.',
  care_and_authenticity = 'Cold wash separately; natural dyes crock. Cooperative tags and workshop visits beat anonymous bulk markets; sniff for chemical indigo versus plant vat dialogue with seller.',
  best_buying_season = 'October–February; avoid monsoon damp during village procurement.',
  updated_at = now()
WHERE slug = 'bagru-block-print';
