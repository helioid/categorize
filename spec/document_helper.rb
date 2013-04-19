# encoding: utf-8

module DocumentHelper
  Query = 'lorem'

  Documents = [
    %q(Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
       tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
       veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
       commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
       velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
       occaecat cupidatat non proident, sunt in culpa qui officia deserunt
       mollit anim id est laborum.),
    %q("Sed ut perspiciatis unde omnis iste natus error sit voluptatem
        accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae
        ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt
        explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut
        odit aut fugit, sed quia consequuntur magni dolores eos qui ratione
        voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum
        quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam
        eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat
        voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam
        corporis suscipit laboriosam, nisi ut aliquid ex ea commodi
        consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate
        velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum
        fugiat quo voluptas nulla pariatur?"),
    %q("At vero eos et accusamus et iusto odio dignissimos ducimus qui
        blanditiis praesentium voluptatum deleniti atque corrupti quos dolores
        et quas molestias excepturi sint occaecati cupiditate non provident,
        similique sunt in culpa qui officia deserunt mollitia animi, id est
        laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita
        distinctio. Nam libero tempore, cum soluta nobis est eligendi optio
        cumque nihil impedit quo minus id quod maxime placeat facere possimus,
        omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem
        quibusdam et aut officiis debitis aut rerum necessitatibus saepe
        eveniet ut et voluptates repudiandae sint et molestiae non recusandae.
        Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis
        voluptatibus maiores alias consequatur aut perferendis doloribus
        asperiores repellat.)
  ]

  Unitis = [
    %w(unitus community credit union unitus community credit union offering
       full loan banking services multnomah washington clackamas marion polk
       yamhill clark counties),
    %w(unitis contractor supplies clamps hammers striking tools hand saws
       shears knives marking measuring layout pliers plumbing tools prying
       tools screwdrivers nutdrivers),
    %w(unitis european organization cosmetic ingredients industries unitis
       federates companies cosmetic ingredients sector producers evaluation
       companies distributors represents them contributes improving),
    %w(unitis availability high quality energy unitis experience personnel
       spend time international many many cultures over five years),
    %w(viribus unitis wikipedia free encyclopedia viribus unitis first austro
       hungarian dreadnought battleship tegetthoff class name meaning united
       forces personal motto emperor),
    %w(viribus unitis wikipedia free encyclopedia polisportiva viribus unitis
       italian association football club located somma vesuviana campania
       currently plays serie colors blue),
    %w(mark unitis south barre mylife 8482 wondering mark unitis learn find
       people reconnect catch mylife),
    %w(viribus unitis austro hungarian battleship model austro hungarian
       battleship viribus unitis story),
    %w(unitis industrial supply linkedin join linkedin connected unitis
       industrial supply free access insightful information network thousands
       companies),
    %w(viribus unitis does stand acronyms acronym definition volume unit view
       vulnerable iucn list threatened species category vanuatu country code
       level domain),
    %w(viribus unitis youtube youtube broadcast yourself stabsmusikkorps
       bundeswehr zapfenstreich nigsufer dresden jahre armee einheit germany
       celebrates years united armed forces),
    %w(viribus unitis yacht supply croatia yacht supply adriatic yachts mega
       yachts sailing boats through interactive electronic catalog over 1500
       items different categories),
    %w(michaele unitis atglen mylife 8482 people finder tool allows find
       friends like michaele unitis easily back touch people miss mylife),
    %w(trenches special assault viribus unitis article originally appeared 1998
       issue news under title italian frogmen attack austrian dreadnought),
    %w(unitis contractor supplies diego california click reports research
       company background detailed company profile credit financial reports
       unitis contractor supplies),
    %w(viribus unitis yesterday 2007r turek youtube koncert viribus unitis
       support sdmu 2007r aula turek),
    %w(angela unitis obstetrician gynecologist novi angela unitis obstetrician
       gynecologist novi quality indicators special expertise doctor unitis),
    %w(viribus unitis hooded blazer awesomer mixing brown pinstripe blazer
       white nail headed hood sounds crazy works viribus unitis edgy being
       tacky intricate front back white),
    %w(unitis puertas portones automaticos door gate automation sitio unitis
       esta empresa especializada automatizaci puertas aberturas general
       orientados hacia industria construcci nueva),
    %w(johnny unitis encyclopedia topics reference wikipedia free encyclopedia
       2001 2006 wikipedia contributors article licensed under free
       documentation license last updated tuesday july),
    %w(sinking viribus unitis ante website true history fate viribus unitis
       class battleships),
    %w(viribus unitis facts discussion forum encyclopedia name meaning united
       forces personal motto emperor franz joseph viribus unitis ordered austro
       hungarian navy 1908),
    %w(viribus unitis strike models been little torn putting hull figure better
       hull available those really want than),
    %w(viribus unitis wordreference forums nice idea latin viribus unitis
       english united forces turkish birle kuvvetler russian),
    %w(italiano uniti fotolog fotolog share photos make friends las_unitis hasn
       added groups their friends favorites list explore groups here),
    %w(gallery viribus unitis drawings plans viribus unitis drawing showing
       viribus unitis after sinking wreck initially settled),
    %w(unitis marras angela reviews southfield angies list reviews trust unitis
       marras angela angie list members),
    %w(austria hungary germany silver viribus unitis medal austro hungary
       germany silver medal period reserve shipping cost countries ebay),
    %w(kennel viribus unitis palokin momo jasmin first long haired female
       palokin like dream juno second foundation bitch viribus unitis angerona
       martta),
    %w(viribus unitis budme jednotni translators translator kudoz lithuanian
       english translation viribus unitis budme jednotni literary),
    %w(adrea unitis founder child success network zoominfo find business
       contact information adrea unitis founder child success network work
       history affiliations),
    %w(viribus unitis project model model austro hungarian battleship viribus
       unitis story),
    %w(restare uniti info facebook restare uniti currently planning stages
       documentary finding finance extend short film into full length feature
       version starring),
    %w(viribus unitis definition viribus unitis synonym definitions viribus
       unitis synonyms antonyms derivatives viribus unitis analogical
       dictionary viribus unitis italian),
    %w(classifica ufficiale allievi regionali giorne facebook viribus unitis
       1917 wrote note titled classifica ufficiale allievi regionali giorne
       read full text here),
    %w(viribus unitis definition viribus unitis synonym definitions viribus
       unitis synonyms antonyms derivatives viribus unitis analogical
       dictionary viribus unitis english),
    %w(viribus unitis history viribus unitis founded november 23th 2001 meska
       korpen goal clan still play lose team),
    %w(unitis private company information businessweek unitis company research
       investing information find executives latest company news),
    %w(viribus unitis wikipedia viribus unitis locuzione latina significa
       letteralmente forze unite liberamente traducibile tutti assieme unione
       forza),
    %w(unitis european organization cosmetic ingredients industries unitis
       federates companies cosmetic ingredients sector producers evaluation
       companies distributors represents them contributes improving quality),
    %w(viribus unitis austria hungary battleship medal ebay squaretrade style
       text align center http auctiva java border table align center style text
       decoration),
    %w(austro hungarian austrian sword viribus unitis 1878 bids original world
       austro hungarian model 1878 sword saber scabbard beautiful sword mother
       pearl grips ornate hilt),
    %w(viribus unitis home laatste update juni 2011 heeft vraag mail info
       viribusunitisdewijk),
    %w(kennel viribus unitis breeders suonsivu emilia honkanen puppies born
       puppies born 2010 puppies girl born evening everything went well ruska),
    %w(viribus unitis wikipedia viribus unitis corazzata della kriegsmarine
       imperiale regia marina austro ungarica nave doveva nome motto dell
       imperatore),
    %w(viribus unitis 1918 wreck site viribus unitis 1918 wreck wreck database
       means value inherited szent istv 1918 reference tegetthoff class
       battleship hung),
    %w(polisportiva viribus unitis sito ufficiale contatore siti),
    %w(fundacja viribus unitis czonymi babicach fundacja viribus unitis czonymi
       babice jana prowadzimy rodowiskowy samopomocy),
    %w(unitis unitis 2011 1024),
    %w(neptune ships viribus unitis model viribus unitis built neptune ship
       modeling club makeevka ukraine),
  ]

  Helioid = [
    %q(Using Helioid search refinement tools you can find and explore what
       you are looking for by interactively narrowing your search results.
       Helioid is a visual search),
    %q(Helioid is a visual search and aggregation tool that enables
       information exploration. Using Helioid's search refinement tools you
       can find.),
    %q(The floor of Silicon Valley is littered with the carcasses of failed
       search startups. Without billions of dollars in resources like
       Microsoft or a tight),
    %q(Dictionary of Difficult Words - helioid. helioid. a. like the sun.
       Find a word. Find a difficult word here. Click on a letter to find
       the word: A B C D E F G H I J K L M N),
    %q(Welcome to the company profile of Helioid on LinkedIn. Using
       Helioid's search refinement tools you can find and explore what
       you're looking for by)
  ]

  def self.records_to_tokens
    Categorize::Model.lexicalize(Documents)
  end
end
