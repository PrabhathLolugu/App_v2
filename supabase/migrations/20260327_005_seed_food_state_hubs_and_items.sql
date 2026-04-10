-- Seed state-level native cultural Hindu food catalog.
-- Explicitly avoids Mughal court-origin dishes.

WITH hub_seed(state_code, state_name, latitude, longitude, pin_hide_zoom_max, sort_order) AS (
  VALUES
    ('IN-AP','Andhra Pradesh',15.9129,79.7400,7.6,1),
    ('IN-AR','Arunachal Pradesh',28.2180,94.7278,8.6,2),
    ('IN-AS','Assam',26.2006,92.9376,8.3,3),
    ('IN-BR','Bihar',25.0961,85.3131,7.9,4),
    ('IN-CT','Chhattisgarh',21.2787,81.8661,7.7,5),
    ('IN-GA','Goa',15.2993,74.1240,8.9,6),
    ('IN-GJ','Gujarat',22.2587,71.1924,7.5,7),
    ('IN-HR','Haryana',29.0588,76.0856,8.1,8),
    ('IN-HP','Himachal Pradesh',31.1048,77.1734,8.5,9),
    ('IN-JH','Jharkhand',23.6102,85.2799,8.0,10),
    ('IN-KA','Karnataka',15.3173,75.7139,7.4,11),
    ('IN-KL','Kerala',10.8505,76.2711,8.0,12),
    ('IN-MP','Madhya Pradesh',22.9734,78.6569,7.3,13),
    ('IN-MH','Maharashtra',19.7515,75.7139,7.2,14),
    ('IN-MN','Manipur',24.6637,93.9063,8.7,15),
    ('IN-ML','Meghalaya',25.4670,91.3662,8.7,16),
    ('IN-MZ','Mizoram',23.1645,92.9376,8.8,17),
    ('IN-NL','Nagaland',26.1584,94.5624,8.7,18),
    ('IN-OR','Odisha',20.9517,85.0985,7.8,19),
    ('IN-PB','Punjab',31.1471,75.3412,8.1,20),
    ('IN-RJ','Rajasthan',27.0238,74.2179,7.2,21),
    ('IN-SK','Sikkim',27.5330,88.5122,8.8,22),
    ('IN-TN','Tamil Nadu',11.1271,78.6569,7.4,23),
    ('IN-TS','Telangana',18.1124,79.0193,7.8,24),
    ('IN-TR','Tripura',23.9408,91.9882,8.7,25),
    ('IN-UP','Uttar Pradesh',26.8467,80.9462,7.1,26),
    ('IN-UK','Uttarakhand',30.0668,79.0193,8.4,27),
    ('IN-WB','West Bengal',22.9868,87.8550,7.8,28),
    ('IN-AN','Andaman and Nicobar Islands',11.7401,92.6586,8.9,29),
    ('IN-CH','Chandigarh',30.7333,76.7794,9.0,30),
    ('IN-DN','Dadra and Nagar Haveli and Daman and Diu',20.3974,72.8328,8.9,31),
    ('IN-DL','Delhi',28.7041,77.1025,8.9,32),
    ('IN-JK','Jammu and Kashmir',33.7782,76.5762,8.5,33),
    ('IN-LA','Ladakh',34.1526,77.5770,8.9,34),
    ('IN-LD','Lakshadweep',10.5667,72.6417,9.0,35),
    ('IN-PY','Puducherry',11.9416,79.8083,8.9,36)
)
INSERT INTO public.food_state_hubs (
  slug, state_code, state_name, latitude, longitude, pin_hide_zoom_max, sort_order, is_published
)
SELECT
  lower(concat('food-', replace(state_code, 'IN-', ''))),
  state_code,
  state_name,
  latitude,
  longitude,
  pin_hide_zoom_max,
  sort_order,
  TRUE
FROM hub_seed
ON CONFLICT (state_code) DO UPDATE SET
  slug = EXCLUDED.slug,
  state_name = EXCLUDED.state_name,
  latitude = EXCLUDED.latitude,
  longitude = EXCLUDED.longitude,
  pin_hide_zoom_max = EXCLUDED.pin_hide_zoom_max,
  sort_order = EXCLUDED.sort_order,
  is_published = EXCLUDED.is_published;

WITH item_seed(state_code, food_slug, food_name, short_description, about_food, history, ingredients, preparation_style, serving_context, nutrition_notes, best_season, sort_order) AS (
  VALUES
    ('IN-AP','pulihora','Pulihora','Tamarind rice offered in many Andhra temples and festivals.','Pulihora is a sacred festive rice preparation known for balance of tang, spice, and sesame aroma.','Temple kitchens and home ritual calendars both preserve this preparation.','Rice, tamarind pulp, sesame oil, curry leaves, peanuts, turmeric, red chilli.','Cooked rice is cooled, mixed with seasoned tamarind reduction and tempered spices.','Common during Navaratri, vrata breaks, and as prasadam.','Balanced carbohydrate meal with healthy fats from sesame and peanuts.','Year-round',1),
    ('IN-AP','bellam-pongali','Bellam Pongali','Jaggery sweet pongal linked to Sankranti and temple offerings.','Bellam pongali is a sweet ritual dish cooked with rice, moong dal, ghee, and jaggery.','Harvest festivals in Andhra popularized this as a sacred gratitude food.','Rice, moong dal, jaggery, ghee, cardamom, cashews, raisins.','Slow-cooked until creamy and finished with ghee-roasted dry fruits.','Served during Sankranti and as naivedyam.','Protein from dal and minerals from jaggery.','Winter and harvest season',2),
    ('IN-AR','apong-rice-cake','Apong Rice Cake','Local rice-cake offering style used in many seasonal community rituals.','This rice-cake tradition reflects agrarian reverence, seasonal gratitude, and local sacred-food continuity.','Rice harvest practices in Arunachal communities preserved this simple ceremonial preparation.','Rice flour, jaggery, coconut, sesame.','Batter is steamed in leaf wraps for a soft, mildly sweet cake.','Seasonal puja meals and community feasts.','Lightly sweet, grain-based energy food.','Post-harvest season',1),
    ('IN-AS','til-pitha','Til Pitha','Sesame-jaggery rice roll prepared during Magh Bihu.','Til pitha is a handmade festive snack representing agrarian gratitude and winter warmth.','Bihu households preserved it as a ritual sweet and community sharing food.','Rice flour, black sesame, jaggery.','Rice batter sheet is pan-roasted and rolled with sesame-jaggery filling.','Festival breakfast and ceremonial sharing during Bihu.','Rich in calcium, iron, and healthy fats from sesame.','Winter',1),
    ('IN-AS','khar','Khar','Traditional alkaline Assamese sattvic preparation served with rice.','Khar is a foundational Assamese dish made with natural alkali and local vegetables or pulses.','It originates from indigenous kitchen science and ritual meal sequencing.','Raw papaya or pulses, banana peel alkali, mustard oil, salt, spices.','Cooked gently with alkaline water for a distinct flavor profile.','Often first course in traditional Assamese meals.','Digestive support and low-oil composition.','Year-round',2),
    ('IN-BR','litti-chokha','Litti Chokha','Roasted wheat dumpling with sattu, served with smoked vegetable mash.','A rooted Bihar staple, litti chokha reflects local grain culture and fire-cooked tradition.','Rural kitchens and pilgrimage routes helped sustain this iconic preparation.','Whole wheat flour, roasted gram flour, ajwain, mustard oil, eggplant, tomato, potato.','Stuffed dough balls are roasted and paired with smoked chokha.','Common in festive gatherings and travel food traditions.','High fiber, plant protein, and complex carbs.','Year-round',1),
    ('IN-BR','thekua','Thekua','Jaggery wheat sweet made for Chhath and puja rituals.','Thekua is a sacred sweet with long shelf life and ritual purity association.','It is deeply connected with Chhath vrat offerings in Bihar households.','Wheat flour, jaggery, ghee, fennel, dry coconut.','Dough is hand-shaped and deep-fried to a golden crisp texture.','Core Chhath prasadam and festive sweet.','Energy-dense and mineral rich from jaggery.','Autumn and festival periods',2),
    ('IN-CT','faraa','Faraa','Steamed rice dumpling from Chhattisgarh ritual kitchens.','Faraa is a gentle steamed food linked with local fasting and festival vegetarian meals.','Traditional village cooking retained this grain-based sattvic dumpling.','Rice flour, lentil paste, cumin, coriander, salt.','Dumplings are shaped, steamed, and lightly tempered.','Festival thali and vrat-friendly home meals.','Steamed and light on oil, moderate protein.','Year-round',1),
    ('IN-GA','khatkhate','Khatkhate','Goan Saraswat mixed-vegetable curry with coconut base.','Khatkhate is a temple-style vegetarian preparation with balanced spice and coconut depth.','Saraswat Hindu households maintained it in sacred-day cooking.','Pumpkin, drumstick, beans, coconut, red chilli, cumin.','Vegetables are simmered and blended with fresh coconut masala.','Temple and festival vegetarian spreads.','Fiber-rich mixed vegetable curry.','Monsoon and festive periods',1),
    ('IN-GJ','undhiyu','Undhiyu','Seasonal winter mixed-vegetable dish from Gujarat.','Undhiyu celebrates local winter produce, spice layering, and shared festive cooking.','Community cooking during Uttarayan popularized regional variants.','Surti papdi, yam, potatoes, methi muthia, coconut, sesame, spices.','Vegetables are slow-cooked with masala and steamed dumplings.','Served during Uttarayan and winter family feasts.','Fiber-rich and micronutrient dense due to mixed vegetables.','Winter',1),
    ('IN-GJ','khichdi-kadhi','Khichdi Kadhi','Sattvic comfort combination central to many Gujarati homes.','Soft rice-lentil khichdi with yogurt-based kadhi is light, balanced, and ritual-friendly.','It became a staple due to digestibility and easy adaptability for fasting days.','Rice, moong dal, yogurt, gram flour, turmeric, cumin, curry leaves.','Khichdi is pressure-cooked; kadhi is simmered with tempered spices.','Daily dinner and post-fasting comfort meal.','Balanced protein-carb meal with probiotic support from yogurt.','Year-round',2),
    ('IN-HR','bajra-khichdi','Bajra Khichdi','Pearl millet and lentil one-pot from Haryana winter kitchens.','Bajra khichdi reflects hardy grain traditions and ritual vegetarian household foodways.','Rural agrarian communities preserved it as a warming staple.','Pearl millet, moong dal, ghee, cumin, asafoetida.','Millet and dal are pressure-cooked and tempered with ghee spices.','Winter meals and simple festive lunches.','High fiber and sustained energy release.','Winter',1),
    ('IN-HP','madra','Madra','Yogurt-based chickpea curry served in Himachali ceremonial meals.','Madra is a key dish in temple-influenced Dham feasts of Himachal.','Pahadi ritual feasts institutionalized this rich sattvic curry.','Chickpeas, yogurt, ghee, whole spices.','Slow simmering in yogurt gravy with gentle spice layering.','Dham feasts and festival offerings.','Protein-rich legume preparation.','Cool seasons',1),
    ('IN-JH','dhuska','Dhuska','Rice-lentil fried bread eaten with local vegetable curries.','Dhuska represents indigenous grain blending and festive sharing traditions in Jharkhand.','Village fairs and ritual gatherings sustained this preparation.','Rice, chana dal, urad dal, cumin, green chilli.','Fermented batter is ladled and fried into thick discs.','Festive snacks and community events.','Carb-protein combination with fermented batter benefits.','Year-round',1),
    ('IN-KA','bisi-bele-bath','Bisi Bele Bath','Temple-influenced lentil-rice one-pot meal from Karnataka.','Bisi bele bath combines rice, lentils, vegetables, and aromatic masala in a complete meal format.','Mysore and temple kitchens codified its spice profile over time.','Rice, toor dal, vegetables, tamarind, bisi bele powder, ghee.','Cooked in stages and blended to a soft, aromatic consistency.','Festival lunches, temple canteens, and home feasts.','Balanced macro meal with vegetables and protein.','Year-round',1),
    ('IN-KA','kosambari','Kosambari','Sattvic lentil salad served in pujas and festive meals.','Kosambari is a cooling, protein-rich side made with soaked lentils and coconut.','It is commonly associated with Varamahalakshmi and Navaratri offerings.','Moong dal, cucumber, coconut, lemon, curry leaves, green chilli.','No-cook assembly with light tempering.','Puja prasadam and festive thali side dish.','High plant protein and hydration support.','Summer and festivals',2),
    ('IN-KL','avial','Avial','Coconut-curd mixed vegetable dish rooted in Kerala temple cuisine.','Avial is a signature sattvic preparation balancing many local vegetables in coconut base.','Classical sadya tradition preserved avial as a mandatory ceremonial dish.','Raw banana, yam, ash gourd, drumstick, coconut, curd, curry leaves.','Vegetables are steamed and folded into coconut-curd masala.','Onam sadya and temple-oriented vegetarian feasts.','Fiber-rich with healthy fats from coconut.','Monsoon and festival seasons',1),
    ('IN-KL','palada-payasam','Palada Payasam','Milk-rice ada kheer served in Kerala festivals and temple feasts.','Palada payasam is a celebratory sweet linked with temple and sadya traditions.','Temple kitchens and family ceremonies sustained its recipe lineage.','Rice ada, milk, sugar or jaggery, ghee, cardamom.','Slow reduction of milk with ada until creamy and aromatic.','Onam, Vishu, birthdays, and ceremonial meals.','Calcium-rich festive dessert.','Festival periods',2),
    ('IN-MP','dal-bafla','Dal Bafla','Wheat dumpling with ghee and lentils, a regional ritual comfort food.','Dal bafla pairs roasted wheat dough balls with spiced dal and ghee.','Malwa and central regions retained it as a festive and communal meal.','Wheat flour, semolina, toor dal, ghee, cumin, asafoetida.','Bafla is boiled then baked, served crushed with dal and ghee.','Family feasts and religious community meals.','Protein-carb balanced with satiating fats.','Year-round',1),
    ('IN-MP','bhutte-ka-kees','Bhutte ka Kees','Spiced grated corn preparation from Madhya Pradesh.','This local specialty transforms fresh corn into a soft, fragrant snack-curry dish.','Street and home kitchens in Malwa preserved this culinary identity.','Fresh corn, milk, ghee, green chilli, mustard seeds, turmeric.','Corn is grated and slow-cooked with milk and spices.','Evening snack and festive side.','Energy-rich and seasonal micronutrients from corn.','Monsoon and post-monsoon',2),
    ('IN-MH','puran-poli','Puran Poli','Sweet lentil flatbread central to many Maharashtrian Hindu festivals.','Puran poli is a ritual festive bread with chana dal-jaggery filling and ghee finish.','Gudi Padwa and Holi traditions sustained this celebratory preparation.','Wheat flour, chana dal, jaggery, cardamom, ghee.','Filled dough is rolled thin and roasted on tawa with ghee.','Festival main sweet and puja offering.','Protein and iron from lentils and jaggery.','Spring festivals',1),
    ('IN-MH','sabudana-khichdi','Sabudana Khichdi','Fasting meal popular in vrat observances across Maharashtra.','Sabudana khichdi is a sattvic vrat dish balancing starch, peanuts, and mild spices.','Temple and household fasting traditions normalized its ritual role.','Soaked tapioca pearls, peanuts, potato, cumin, curry leaves, lemon.','Light stir-cook technique preserves soft pearls and nutty texture.','Ekadashi and vrat meals.','Quick energy and moderate protein from peanuts.','Year-round fasting cycles',2),
    ('IN-MN','chakhao-kheer','Chakhao Kheer','Black rice kheer prepared in many devotional and festive contexts.','Chakhao kheer uses aromatic black rice and milk to create a ceremonial sweet.','Traditional Manipuri households preserved this festive offering style.','Black rice, milk, jaggery, cardamom, nuts.','Rice is slow-cooked in milk until deep purple and creamy.','Festival sweet and sacred-day dessert.','Antioxidant-rich rice with calcium from milk.','Festival season',1),
    ('IN-ML','pumaloi','Pumaloi','Steamed powdered rice dish used in local sacred-day meals.','Pumaloi is a minimally processed rice preparation connected to community feasts and rituals.','Highland grain traditions preserved this steamed staple.','Powdered rice, water, salt.','Rice powder is steamed into soft fluffy mounds.','Served with vegetarian accompaniments during ceremonies.','Simple grain meal, light and digestible.','Year-round',1),
    ('IN-MZ','bai','Bai','Mild herb-vegetable stew built on local greens and roots.','Bai is a gentle indigenous preparation adapted into vegetarian festive tables.','Mountain household foodways conserved this clean-flavor style.','Seasonal greens, bamboo shoots, pumpkin, beans, herbs.','Ingredients are simmered without heavy spice for a clean broth.','Community meals and simple sacred-day cooking.','High-fiber, low-oil vegetable dish.','Monsoon and post-monsoon',1),
    ('IN-NL','sticky-rice-cake','Sticky Rice Cake','Handmade steamed rice cake for festivals and ancestral offerings.','This rice-cake format reflects grain-centric ritual food in hill communities.','Ceremonial rice use shaped multiple local variants.','Glutinous rice, jaggery, sesame, banana leaf.','Rice paste is wrapped in leaves and steamed.','Festival sharing and community rituals.','Naturally gluten-free and energy rich.','Harvest and winter season',1),
    ('IN-OR','dalma','Dalma','Lentil and vegetable stew deeply rooted in Odia temple cuisine.','Dalma is a no-onion no-garlic sattvic dish associated with Jagannath food traditions.','Puri temple food systems kept dalma central to ritual meal practice.','Toor/moong dal, raw papaya, pumpkin, plantain, cumin, ghee.','Pressure-cooked lentils with vegetables and light roasted spice.','Served with rice in temple style and home rituals.','Balanced protein and fiber meal.','Year-round',1),
    ('IN-OR','khiri','Khiri','Odia kheer variant used as naivedyam and festive dessert.','Khiri is a slow-cooked milk-rice sweet with devotional significance.','Temple and household offerings preserved this satvik sweet over generations.','Rice, milk, jaggery or sugar, cardamom, bay leaf.','Milk is reduced and rice simmered until thick and fragrant.','Naivedyam during puja and special vrata days.','Calcium and quick energy source.','Festival days',2),
    ('IN-PB','makki-sarson','Makki Roti with Sarson Saag','Seasonal winter staple based on indigenous grains and greens.','This pairing reflects Punjab agrarian winter cuisine and festive home cooking.','Village hearth cooking and harvest cycles shaped this iconic meal.','Maize flour, mustard greens, spinach, ginger, white butter.','Greens are slow-cooked and hand-mashed; rotis are griddled fresh.','Lohri season and winter family meals.','Iron-rich greens with complex carbohydrates.','Winter',1),
    ('IN-PB','panjiri','Panjiri','Roasted wheat and dry-fruit prasadam-style sweet blend.','Panjiri is offered in many Hindu ceremonies and consumed for strength.','Temple bhog and postpartum traditions preserved region-specific variations.','Whole wheat flour, ghee, sugar or jaggery, nuts, edible gum.','Ingredients are roasted separately and mixed into aromatic crumb.','Prasadam, festive sweet, and wellness food.','Energy dense and micronutrient rich.','Winter and ritual periods',2),
    ('IN-RJ','dal-baati-churma','Dal Baati Churma','Rajasthan festive trio of lentils, baked wheat balls, and sweet crumble.','This meal showcases desert-adapted grain use and ceremonial family cooking.','Warrior and pastoral food systems shaped its robust format.','Wheat flour, mixed dals, ghee, jaggery/sugar.','Baati is baked, dal is tempered, churma is ghee-roasted crumble.','Wedding feasts, temple bhandaras, and festivals.','High energy and protein profile.','Cooler months and festivals',1),
    ('IN-RJ','ghevar','Ghevar','Honeycomb disc sweet associated with Teej and Shravan rituals.','Ghevar is a ceremonial sweet tied to monsoon festivals in Rajasthan.','Royal confectioners popularized nuanced syrup and rabri finishes.','Refined flour batter, ghee, sugar syrup, saffron, milk solids.','Batter is fried in layers, soaked lightly, then topped.','Teej, Raksha Bandhan, and festive gifting.','Occasional high-energy festive dessert.','Monsoon',2),
    ('IN-SK','sel-roti','Sel Roti','Ring-shaped rice bread used in festive Himalayan Hindu traditions.','Sel roti is a ceremonial rice bread with deep festive significance.','Borderland Himalayan households preserved this ritual recipe.','Rice batter, ghee, sugar, cardamom.','Fermented batter is shaped in rings and deep-fried.','Dashain-like festive contexts and community celebrations.','Energy rich festive bread.','Festival periods',1),
    ('IN-TN','sakkarai-pongal','Sakkarai Pongal','Sacred jaggery-rice sweet central to Tamil Hindu temple offerings.','Sakkarai pongal symbolizes abundance and gratitude in agrarian devotion.','Pongal festival and temple naivedyam preserved canonical methods.','Rice, moong dal, jaggery, ghee, cashews, cardamom.','Cooked to soft consistency and enriched with ghee tempering.','Thai Pongal and temple offerings.','Protein-carb balanced festive sweet.','Harvest season',1),
    ('IN-TN','kozhukattai','Kozhukattai','Steamed rice dumpling offered during Ganesha worship.','Kozhukattai represents ritual purity and handmade devotional cooking.','Vinayaka Chaturthi traditions institutionalized sweet and savory variants.','Rice flour, coconut, jaggery, sesame, cardamom.','Rice dough shells are filled and steamed.','Vinayaka Chaturthi naivedyam and festive snack.','Steamed preparation with moderate sweetness.','Festival periods',2),
    ('IN-TS','sakinalu','Sakinalu','Crisp rice-flour festival snack from Telangana homes.','Sakinalu is prepared in ritual batches during Sankranti celebrations.','Household women-led festive cooking preserved this snack craft.','Rice flour, sesame, ajwain, oil, salt.','Dough ropes are hand-coiled and deep-fried.','Sankranti and gift exchanges.','Carb-rich festive snack with sesame minerals.','Harvest season',1),
    ('IN-TS','telangana-pulihora','Pulihora (Telangana Style)','Tangy tamarind rice used in pujas and temple-style serving.','A core satvik rice dish in Telangana ritual food spread.','Temple offerings and community feasts reinforced this preparation.','Rice, tamarind, turmeric, peanuts, curry leaves, mustard seeds.','Tempered tamarind mix is folded into cooled rice.','Puja meals and festival feasts.','Moderate energy and healthy fats from peanuts.','Year-round',2),
    ('IN-TR','awandru','Awandru','Colocasia stem curry adapted into vegetarian ritual home cooking.','Awandru reflects Tripura local produce and traditional spice methods.','Community cooking methods preserved this indigenous preparation.','Colocasia stem, rice paste, ginger, green chilli, local herbs.','Stems are simmered with thickened spice base.','Served in ritual vegetarian meals and family feasts.','Fiber-rich and seasonal mineral profile.','Monsoon',1),
    ('IN-UP','kachori-sabzi','Kachori Sabzi','Traditional breakfast pairing with roots in temple-town food circuits.','This regionally diverse dish is tied to festive mornings and bazaar heritage.','Pilgrimage cities expanded kachori variants into ritual and travel food.','Flour, lentil or spice filling, potato curry, asafoetida.','Stuffed discs are fried and served with spiced sabzi.','Festive mornings and temple-town breakfast culture.','Energy dense occasional meal.','Year-round',1),
    ('IN-UP','mathura-peda','Mathura Peda','Milk-solid sweet linked to Krishna devotion traditions.','Peda is a major prasad sweet in Krishna temples and pilgrim circuits.','Temple commerce and ritual offerings preserved local method.','Khoya, sugar, cardamom, ghee.','Khoya is slow-roasted and shaped into discs.','Janmashtami and temple prasad.','Calcium-rich festive sweet.','Festival periods',2),
    ('IN-UK','kafuli','Kafuli','Garhwali green-leaf curry with sattvic mountain profile.','Kafuli highlights local greens and simple tempering in Himalayan Hindu cuisine.','Mountain households sustained it as a nutrient-rich staple.','Spinach, fenugreek leaves, rice flour, yogurt, mustard oil.','Greens are pureed and simmered to thick consistency.','Home meals and ritual vegetarian days.','Iron and folate rich green dish.','Spring and monsoon',1),
    ('IN-UK','jhangora-kheer','Jhangora Kheer','Barnyard millet kheer used in vrat and festive meals.','This mountain sweet uses indigenous millet and is favored in fasting menus.','Traditional millet agriculture kept it central in local ceremonial cuisine.','Barnyard millet, milk, jaggery or sugar, cardamom, nuts.','Millet is simmered in milk until creamy and thick.','Vrat meals and festival desserts.','Gluten-free with complex carbs.','Year-round',2),
    ('IN-WB','shukto','Shukto','Bitter-sweet vegetable medley that opens traditional Bengali meals.','Shukto balances flavors through gentle spice and seasonal vegetables.','Classical Bengali home menus preserved this structured first-course dish.','Bitter gourd, raw banana, drumstick, potato, milk, panch phoron.','Vegetables are cooked in sequence and lightly finished with milk.','Ritual family meals and festive thalis.','High fiber and digestive support.','Year-round',1),
    ('IN-WB','narkel-naru','Narkel Naru','Coconut-jaggery sweet prepared during Lakshmi and Kali puja seasons.','Narkel naru is a devotional sweet with simple ingredients and ritual relevance.','Household puja traditions made it a recurring festival preparation.','Fresh coconut, jaggery, cardamom.','Mixture is reduced and hand-rolled into balls.','Puja prasadam and festive gifting.','Natural fats and minerals from coconut and jaggery.','Autumn festivals',2),
    ('IN-AN','coconut-rice-prasadam','Coconut Rice Prasadam','Coconut-rich rice preparation used in island temple offerings.','This preparation blends rice, coconut, and mild spices for sacred-day serving.','Island Hindu households integrated local coconut abundance into ritual foods.','Rice, coconut, curry leaves, sesame oil, mild spices.','Cooked rice is folded with coconut tempering.','Temple visits and festive naivedyam.','Medium-chain fats from coconut and steady carbs from rice.','Year-round',1),
    ('IN-CH','atta-pinni','Atta Pinni','Roasted wheat sweet served in puja and winter wellness traditions.','Pinni is an energy-rich sweet associated with ceremonial sharing.','North Indian Hindu households normalized it as prasad and festive sweet.','Whole wheat flour, ghee, jaggery, nuts.','Flour is roasted in ghee and shaped with jaggery syrup.','Puja, winter gifting, and family rituals.','Energy dense with micronutrients from nuts and jaggery.','Winter',1),
    ('IN-DN','dudh-pak','Dudh Pak','Milk-rice saffron sweet used in western Indian festive rituals.','Dudh pak is a ceremonial kheer style dessert valued for devotional serving.','Gujarati and coastal Hindu communities transmitted this ritual recipe.','Milk, rice, saffron, cardamom, nuts, sugar or jaggery.','Milk is reduced and simmered with rice and aromatics.','Temple feasts and festive meals.','Calcium-rich festive dessert.','Festival periods',1),
    ('IN-DL','bedmi-puri-aloo','Bedmi Puri Aloo','Old Delhi Hindu breakfast with temple-town festive association.','Bedmi puri with aloo sabzi remains a festive morning favorite.','Merchant and pilgrimage circuits sustained this vegetarian breakfast tradition.','Wheat flour, urad dal spice mix, potato curry, asafoetida.','Stuffed puris are fried and paired with spiced potato.','Festive mornings and local ceremonial gatherings.','Carb-protein dense occasional meal.','Year-round',1),
    ('IN-JK','rajma-gogji','Rajma Gogji','Kidney beans with turnip in mountain Hindu household cuisine.','Rajma gogji combines legumes and root vegetables in a warming satvik style.','Jammu Hindu kitchens preserved this seasonal staple.','Rajma, turnip, ginger, cumin, mild spices.','Beans and turnip are slow-cooked to absorb spice and texture.','Winter family meals and fasting-adjacent vegetarian days.','Protein and fiber rich with minerals from roots.','Winter',1),
    ('IN-LA','khambir-ghee','Khambir with Ghee','Whole-grain Ladakhi bread served in simple ceremonial vegetarian meals.','Khambir reflects high-altitude grain culture and devotional hospitality.','Monastic and household traditions kept this bread in everyday sacred contexts.','Whole wheat flour, yeast starter, salt, ghee.','Dough is fermented and griddle-baked thick.','Served with butter tea alternatives and festive meals.','Complex carbs with sustaining satiety.','Cold months',1),
    ('IN-LD','coconut-jaggery-laddoo','Coconut Jaggery Laddoo','Island coconut sweet made for festive sharing and puja offerings.','This laddoo style uses local coconut abundance in devotional sweet making.','Lakshadweep Hindu families preserved coconut-jaggery sweet traditions.','Fresh coconut, jaggery, cardamom.','Mixture is reduced and hand-rolled while warm.','Puja offerings and family celebrations.','Natural fats and minerals from coconut and jaggery.','Year-round',1),
    ('IN-PY','puliyodarai','Puliyodarai','Tamil temple tamarind rice tradition widely served in Puducherry temples.','Puliyodarai is a classic prasadam rice dish with concentrated tamarind spice blend.','Temple liturgical food systems maintain this recipe continuity.','Rice, tamarind, sesame oil, peanuts, curry leaves, red chilli.','Prepared with a shelf-stable tamarind paste and mixed into rice.','Temple prasadam and festive travel food.','Balanced carbs and fats with digestive spices.','Year-round',1)
)
INSERT INTO public.food_state_items (
  hub_id,
  food_name,
  short_description,
  about_food,
  history,
  ingredients,
  preparation_style,
  serving_context,
  nutrition_notes,
  best_season,
  discussion_site_id,
  cover_image_url,
  gallery_urls,
  sort_order,
  is_published
)
SELECT
  h.id,
  i.food_name,
  i.short_description,
  i.about_food,
  i.history,
  i.ingredients,
  i.preparation_style,
  i.serving_context,
  i.nutrition_notes,
  i.best_season,
  (
    substr(md5(concat(i.state_code, '|', i.food_slug)), 1, 8) || '-' ||
    substr(md5(concat(i.state_code, '|', i.food_slug)), 9, 4) || '-' ||
    substr(md5(concat(i.state_code, '|', i.food_slug)), 13, 4) || '-' ||
    substr(md5(concat(i.state_code, '|', i.food_slug)), 17, 4) || '-' ||
    substr(md5(concat(i.state_code, '|', i.food_slug)), 21, 12)
  )::uuid,
  concat(
    'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/state-foods/',
    lower(replace(i.state_code, 'IN-', '')),
    '/',
    i.food_slug,
    '/cover.jpg'
  ),
  ARRAY[
    concat(
      'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/state-foods/',
      lower(replace(i.state_code, 'IN-', '')),
      '/',
      i.food_slug,
      '/gallery/1.jpg'
    )
  ]::text[],
  i.sort_order,
  TRUE
FROM item_seed i
JOIN public.food_state_hubs h ON h.state_code = i.state_code
ON CONFLICT (discussion_site_id) DO UPDATE SET
  food_name = EXCLUDED.food_name,
  short_description = EXCLUDED.short_description,
  about_food = EXCLUDED.about_food,
  history = EXCLUDED.history,
  ingredients = EXCLUDED.ingredients,
  preparation_style = EXCLUDED.preparation_style,
  serving_context = EXCLUDED.serving_context,
  nutrition_notes = EXCLUDED.nutrition_notes,
  best_season = EXCLUDED.best_season,
  cover_image_url = EXCLUDED.cover_image_url,
  gallery_urls = EXCLUDED.gallery_urls,
  sort_order = EXCLUDED.sort_order,
  is_published = EXCLUDED.is_published;

