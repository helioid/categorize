require File.dirname(__FILE__) + '/bow'
require 'rubygems'
include Bow

tokens = [
    ["sentence", "one", "good", "one", "is"],
    ["this", "is", "two", "this", "is", "two"],
    "Note this error occurs most often when having MacPorts Fink or Homebrew installed readline on your system The next most often is when readline development headers are not available at all The above commands solve this by having RVM compile local version inside rvmusr and telling ruby install to use it If you have readline already installed using one of above-mentioned package managers you can use that readline by exchanging location such as following".split(" ")
]

unitis = [
  ["unitus", "community", "credit", "union", "unitus", "community", "credit", "union", "offering", "full", "loan", "banking", "services", "multnomah", "washington", "clackamas", "marion", "polk", "yamhill", "clark", "counties"],
  ["unitis", "contractor", "supplies", "clamps", "hammers", "striking", "tools", "hand", "saws", "shears", "knives", "marking", "measuring", "layout", "pliers", "plumbing", "tools", "prying", "tools", "screwdrivers", "nutdrivers"],
  ["unitis", "european", "organization", "cosmetic", "ingredients", "industries", "unitis", "federates", "companies", "cosmetic", "ingredients", "sector", "producers", "evaluation", "companies", "distributors", "represents", "them", "contributes", "improving"],
  ["unitis", "availability", "high", "quality", "energy", "unitis", "experience", "personnel", "spend", "time", "international", "many", "many", "cultures", "over", "five", "years"],
  ["viribus", "unitis", "wikipedia", "free", "encyclopedia", "viribus", "unitis", "first", "austro", "hungarian", "dreadnought", "battleship", "tegetthoff", "class", "name", "meaning", "united", "forces", "personal", "motto", "emperor"],
  ["viribus", "unitis", "wikipedia", "free", "encyclopedia", "polisportiva", "viribus", "unitis", "italian", "association", "football", "club", "located", "somma", "vesuviana", "campania", "currently", "plays", "serie", "colors", "blue"],
  ["mark", "unitis", "south", "barre", "mylife", "8482", "wondering", "mark", "unitis", "learn", "find", "people", "reconnect", "catch", "mylife"],
  ["viribus", "unitis", "austro", "hungarian", "battleship", "model", "austro", "hungarian", "battleship", "viribus", "unitis", "story"],
  ["unitis", "industrial", "supply", "linkedin", "join", "linkedin", "connected", "unitis", "industrial", "supply", "free", "access", "insightful", "information", "network", "thousands", "companies"],
  ["viribus", "unitis", "does", "stand", "acronyms", "acronym", "definition", "volume", "unit", "view", "vulnerable", "iucn", "list", "threatened", "species", "category", "vanuatu", "country", "code", "level", "domain"],
  ["viribus", "unitis", "youtube", "youtube", "broadcast", "yourself", "stabsmusikkorps", "bundeswehr", "zapfenstreich", "nigsufer", "dresden", "jahre", "armee", "einheit", "germany", "celebrates", "years", "united", "armed", "forces"],
  ["viribus", "unitis", "yacht", "supply", "croatia", "yacht", "supply", "adriatic", "yachts", "mega", "yachts", "sailing", "boats", "through", "interactive", "electronic", "catalog", "over", "1500", "items", "different", "categories"],
  ["michaele", "unitis", "atglen", "mylife", "8482", "people", "finder", "tool", "allows", "find", "friends", "like", "michaele", "unitis", "easily", "back", "touch", "people", "miss", "mylife"],
  ["trenches", "special", "assault", "viribus", "unitis", "article", "originally", "appeared", "1998", "issue", "news", "under", "title", "italian", "frogmen", "attack", "austrian", "dreadnought"],
  ["unitis", "contractor", "supplies", "diego", "california", "click", "reports", "research", "company", "background", "detailed", "company", "profile", "credit", "financial", "reports", "unitis", "contractor", "supplies"],
  ["viribus", "unitis", "yesterday", "2007r", "turek", "youtube", "koncert", "viribus", "unitis", "support", "sdmu", "2007r", "aula", "turek"],
  ["angela", "unitis", "obstetrician", "gynecologist", "novi", "angela", "unitis", "obstetrician", "gynecologist", "novi", "quality", "indicators", "special", "expertise", "doctor", "unitis"],
  ["viribus", "unitis", "hooded", "blazer", "awesomer", "mixing", "brown", "pinstripe", "blazer", "white", "nail", "headed", "hood", "sounds", "crazy", "works", "viribus", "unitis", "edgy", "being", "tacky", "intricate", "front", "back", "white"],
  ["unitis", "puertas", "portones", "automaticos", "door", "gate", "automation", "sitio", "unitis", "esta", "empresa", "especializada", "automatizaci", "puertas", "aberturas", "general", "orientados", "hacia", "industria", "construcci", "nueva"],
  ["johnny", "unitis", "encyclopedia", "topics", "reference", "wikipedia", "free", "encyclopedia", "2001", "2006", "wikipedia", "contributors", "article", "licensed", "under", "free", "documentation", "license", "last", "updated", "tuesday", "july"],
  ["sinking", "viribus", "unitis", "ante", "website", "true", "history", "fate", "viribus", "unitis", "class", "battleships"],
  ["viribus", "unitis", "facts", "discussion", "forum", "encyclopedia", "name", "meaning", "united", "forces", "personal", "motto", "emperor", "franz", "joseph", "viribus", "unitis", "ordered", "austro", "hungarian", "navy", "1908"],
  ["viribus", "unitis", "strike", "models", "been", "little", "torn", "putting", "hull", "figure", "better", "hull", "available", "those", "really", "want", "than"],
  ["viribus", "unitis", "wordreference", "forums", "nice", "idea", "latin", "viribus", "unitis", "english", "united", "forces", "turkish", "birle", "kuvvetler", "russian"],
  ["italiano", "uniti", "fotolog", "fotolog", "share", "photos", "make", "friends", "las_unitis", "hasn", "added", "groups", "their", "friends", "favorites", "list", "explore", "groups", "here"],
  ["gallery", "viribus", "unitis", "drawings", "plans", "viribus", "unitis", "drawing", "showing", "viribus", "unitis", "after", "sinking", "wreck", "initially", "settled"],
  ["unitis", "marras", "angela", "reviews", "southfield", "angies", "list", "reviews", "trust", "unitis", "marras", "angela", "angie", "list", "members"],
  ["austria", "hungary", "germany", "silver", "viribus", "unitis", "medal", "austro", "hungary", "germany", "silver", "medal", "period", "reserve", "shipping", "cost", "countries", "ebay"],
  ["kennel", "viribus", "unitis", "palokin", "momo", "jasmin", "first", "long", "haired", "female", "palokin", "like", "dream", "juno", "second", "foundation", "bitch", "viribus", "unitis", "angerona", "martta"],
  ["viribus", "unitis", "budme", "jednotni", "translators", "translator", "kudoz", "lithuanian", "english", "translation", "viribus", "unitis", "budme", "jednotni", "literary"],
  ["adrea", "unitis", "founder", "child", "success", "network", "zoominfo", "find", "business", "contact", "information", "adrea", "unitis", "founder", "child", "success", "network", "work", "history", "affiliations"],
  ["viribus", "unitis", "project", "model", "model", "austro", "hungarian", "battleship", "viribus", "unitis", "story"],
  ["restare", "uniti", "info", "facebook", "restare", "uniti", "currently", "planning", "stages", "documentary", "finding", "finance", "extend", "short", "film", "into", "full", "length", "feature", "version", "starring"],
  ["viribus", "unitis", "definition", "viribus", "unitis", "synonym", "definitions", "viribus", "unitis", "synonyms", "antonyms", "derivatives", "viribus", "unitis", "analogical", "dictionary", "viribus", "unitis", "italian"],
  ["classifica", "ufficiale", "allievi", "regionali", "giorne", "facebook", "viribus", "unitis", "1917", "wrote", "note", "titled", "classifica", "ufficiale", "allievi", "regionali", "giorne", "read", "full", "text", "here"],
  ["viribus", "unitis", "definition", "viribus", "unitis", "synonym", "definitions", "viribus", "unitis", "synonyms", "antonyms", "derivatives", "viribus", "unitis", "analogical", "dictionary", "viribus", "unitis", "english"],
  ["viribus", "unitis", "history", "viribus", "unitis", "founded", "november", "23th", "2001", "meska", "korpen", "goal", "clan", "still", "play", "lose", "team"],
  ["unitis", "private", "company", "information", "businessweek", "unitis", "company", "research", "investing", "information", "find", "executives", "latest", "company", "news"],
  ["viribus", "unitis", "wikipedia", "viribus", "unitis", "locuzione", "latina", "significa", "letteralmente", "forze", "unite", "liberamente", "traducibile", "tutti", "assieme", "unione", "forza"],
  ["unitis", "european", "organization", "cosmetic", "ingredients", "industries", "unitis", "federates", "companies", "cosmetic", "ingredients", "sector", "producers", "evaluation", "companies", "distributors", "represents", "them", "contributes", "improving", "quality"],
  ["viribus", "unitis", "austria", "hungary", "battleship", "medal", "ebay", "squaretrade", "style", "text", "align", "center", "http", "auctiva", "java", "border", "table", "align", "center", "style", "text", "decoration"],
  ["austro", "hungarian", "austrian", "sword", "viribus", "unitis", "1878", "bids", "original", "world", "austro", "hungarian", "model", "1878", "sword", "saber", "scabbard", "beautiful", "sword", "mother", "pearl", "grips", "ornate", "hilt"],
  ["viribus", "unitis", "home", "laatste", "update", "juni", "2011", "heeft", "vraag", "mail", "info", "viribusunitisdewijk"],
  ["kennel", "viribus", "unitis", "breeders", "suonsivu", "emilia", "honkanen", "puppies", "born", "puppies", "born", "2010", "puppies", "girl", "born", "evening", "everything", "went", "well", "ruska"],
  ["viribus", "unitis", "wikipedia", "viribus", "unitis", "corazzata", "della", "kriegsmarine", "imperiale", "regia", "marina", "austro", "ungarica", "nave", "doveva", "nome", "motto", "dell", "imperatore"],
  ["viribus", "unitis", "1918", "wreck", "site", "viribus", "unitis", "1918", "wreck", "wreck", "database", "means", "value", "inherited", "szent", "istv", "1918", "reference", "tegetthoff", "class", "battleship", "hung"],
  ["polisportiva", "viribus", "unitis", "sito", "ufficiale", "contatore", "siti"],
  ["fundacja", "viribus", "unitis", "czonymi", "babicach", "fundacja", "viribus", "unitis", "czonymi", "babice", "jana", "prowadzimy", "rodowiskowy", "samopomocy"],
  ["unitis", "unitis", "2011", "1024"],
  ["neptune", "ships", "viribus", "unitis", "model", "viribus", "unitis", "built", "neptune", "ship", "modeling", "club", "makeevka", "ukraine"]
]

a = model_bow(unitis)
puts a.inspect
