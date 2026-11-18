from pathlib import Path
import json
root=Path(__file__).resolve().parents[1]
rows=r'''Farm Idle: Coop|Farm Idle: Coop|Farm Idle: Coop|Farm Idle: Coop
Yard|Hof|Cour|Quintal
Barn|Scheune|Grange|Celeiro
Market|Markt|Marché|Mercado
Grow|Ausbauen|Agrandir|Ampliar
The grain barn|Die Kornscheune|La grange à grains|O celeiro de grãos
Farm market|Hofmarkt|Marché de la ferme|Mercado da fazenda
Room to grow|Platz zum Wachsen|Place à la croissance|Espaço para crescer
Farm settings|Hofeinstellungen|Réglages de la ferme|Ajustes da fazenda
%d care days|%d Pflegetage|%d jours de soins|%d dias de cuidados
A little care.\nA happy flock.|Ein wenig Pflege.\nGlückliche Hühner.|Un peu de soin.\nDes poules heureuses.|Um pouco de cuidado.\nGalinhas felizes.
YOUR FARM|DEIN HOF|VOTRE FERME|SUA FAZENDA
Hens|Hühner|Poules|Galinhas
In the nest|Im Nest|Dans le nid|No ninho
Eggs in barn|Eier in der Scheune|Œufs en réserve|Ovos no celeiro
Today's care|Heutige Pflege|Les soins du jour|Cuidados de hoje
Your flock has been cared for today.|Deine Hühner sind heute versorgt.|Vos poules ont reçu leurs soins du jour.|Suas galinhas receberam cuidados hoje.
Collect eggs or fill the trough to keep your care streak going.|Sammle Eier oder fülle den Trog, um deine Pflegeserie fortzusetzen.|Ramassez les œufs ou remplissez la mangeoire pour poursuivre votre série de soins.|Recolha ovos ou encha o comedouro para manter sua sequência de cuidados.
%d eggs collected in all|%d Eier insgesamt gesammelt|%d œufs ramassés au total|%d ovos recolhidos ao todo
Nest check|Ein Blick ins Nest|Un œil au nid|De olho no ninho
Production is paused until you add grain.|Die Produktion pausiert, bis du Korn nachfüllst.|La production attend que vous ajoutiez des grains.|A produção está pausada até você adicionar grãos.
The nest is full. Time to gather!|Das Nest ist voll. Zeit zum Sammeln!|Le nid est plein. À la récolte !|O ninho está cheio. Hora de recolher!
Next egg in %d seconds|Nächstes Ei in %d Sekunden|Prochain œuf dans %d secondes|Próximo ovo em %d segundos
Collect %d eggs|%d Eier sammeln|Ramasser %d œufs|Recolher %d ovos
Feeding time|Fütterungszeit|À table !|Hora de alimentar
Grain in trough|Korn im Trog|Grains dans la mangeoire|Grãos no comedouro
The birds need grain. They will wait safely.|Die Hühner brauchen Korn. Sie warten sicher.|Les poules ont besoin de grains. Elles attendent sans danger.|As galinhas precisam de grãos. Elas esperam em segurança.
Feed lasts %d minutes|Futter reicht für %d Minuten|Nourriture pour %d minutes|Alimento para %d minutos
Fill the trough|Trog füllen|Remplir la mangeoire|Encher o comedouro
Keep the good things growing.|Lass Gutes weiter wachsen.|Cultivez les bonnes choses.|Continue cultivando coisas boas.
Grain reserve|Kornvorrat|Réserve de grains|Reserva de grãos
A walk in the meadow|Ein Spaziergang auf der Wiese|Une balade dans le pré|Um passeio pelo campo
Gather 10 grain for free every 30 minutes. A small harvest keeps your farm going, even with no coins.|Sammle alle 30 Minuten kostenlos 10 Korn. Eine kleine Ernte hält deinen Hof auch ohne Münzen am Laufen.|Ramassez gratuitement 10 grains toutes les 30 minutes. Cette petite récolte fait vivre votre ferme, même sans pièces.|Recolha 10 grãos grátis a cada 30 minutos. Uma pequena colheita mantém sua fazenda ativa, mesmo sem moedas.
Ready in|Bereit in|Disponible dans|Disponível em
Gather 10 grain|10 Korn sammeln|Ramasser 10 grains|Recolher 10 grãos
Farm rhythm|Hofrhythmus|Le rythme de la ferme|Ritmo da fazenda
Each hen uses 1 grain every 10 minutes. Eggs grow only while the trough has grain. A full nest pauses egg storage; feeding still continues.|Jedes Huhn braucht alle 10 Minuten 1 Korn. Eier entstehen nur mit Korn im Trog. Bei vollem Nest stoppt die Eiersammlung; Futter wird weiter verbraucht.|Chaque poule consomme 1 grain toutes les 10 minutes. La production nécessite des grains dans la mangeoire. Un nid plein arrête le stockage des œufs ; les poules continuent de manger.|Cada galinha usa 1 grão a cada 10 minutos. Os ovos são produzidos enquanto há grãos no comedouro. Um ninho cheio pausa o acúmulo de ovos; o consumo de alimento continua.
Each hen lays an egg every %d seconds|Jedes Huhn legt alle %d Sekunden ein Ei|Chaque poule pond un œuf toutes les %d secondes|Cada galinha põe um ovo a cada %d segundos
Progress uses this device's clock. Moving the clock back pauses progress until the saved time is reached.|Der Fortschritt folgt der Gerätezeit. Wird die Uhr zurückgestellt, pausiert er bis zur gespeicherten Zeit.|La progression suit l'horloge de cet appareil. Reculer l'heure la suspend jusqu'à l'heure enregistrée.|O progresso usa o relógio deste aparelho. Atrasar o relógio pausa o progresso até o horário salvo ser alcançado.
From your farm, with love.|Von deinem Hof, mit Liebe.|De votre ferme, avec amour.|Da sua fazenda, com carinho.
All coins are earned here by selling eggs and filling orders. Everything is free to play.|Alle Münzen verdienst du durch Eierverkauf und Aufträge. Das Spiel ist vollständig kostenlos.|Toutes les pièces se gagnent en vendant des œufs et en livrant des commandes. Le jeu est entièrement gratuit.|Todas as moedas são ganhas vendendo ovos e entregando pedidos. O jogo é totalmente gratuito.
Farm stall|Hofstand|Étal de la ferme|Banca da fazenda
One egg earns 3 coins.|Ein Ei bringt 3 Münzen.|Un œuf rapporte 3 pièces.|Um ovo rende 3 moedas.
Sell %d eggs|%d Eier verkaufen|Vendre %d œufs|Vender %d ovos
Stock up|Vorräte auffüllen|Faire des réserves|Reabastecer
20 grain · 12 coins|20 Korn · 12 Münzen|20 grains · 12 pièces|20 grãos · 12 moedas
Buy grain|Korn kaufen|Acheter des grains|Comprar grãos
Make space in the barn before buying more grain.|Schaffe Platz in der Scheune, bevor du mehr Korn kaufst.|Faites de la place dans la grange avant d'acheter des grains.|Abra espaço no celeiro antes de comprar mais grãos.
Neighbor orders|Aufträge der Nachbarn|Commandes des voisins|Pedidos dos vizinhos
The garden kitchen|Die Gartenküche|La cuisine du jardin|A cozinha da horta
The village baker|Die Dorfbäckerei|Le boulanger du village|A padaria da vila
The breakfast table|Der Frühstückstisch|La table du petit déjeuner|A mesa do café
Needs %d eggs|Benötigt %d Eier|Demande %d œufs|Precisa de %d ovos
Deliver eggs|Eier liefern|Livrer les œufs|Entregar ovos
The weekly fair|Der Wochenmarkt|La foire de la semaine|A feira semanal
A fresh set of tasks every Monday. Finish all three for 120 farm coins.|Jeden Montag neue Aufgaben. Erledige alle drei für 120 Hofmünzen.|De nouvelles tâches chaque lundi. Terminez les trois pour gagner 120 pièces de ferme.|Novas tarefas toda segunda-feira. Conclua as três para ganhar 120 moedas da fazenda.
Collect eggs|Eier sammeln|Ramasser des œufs|Recolher ovos
Fill neighbor orders|Nachbaraufträge erfüllen|Livrer les voisins|Atender os vizinhos
Add grain to the trough|Korn in den Trog füllen|Ajouter des grains à la mangeoire|Adicionar grãos ao comedouro
Fair completed|Markt abgeschlossen|Foire terminée|Feira concluída
Collect 120 coins|120 Münzen abholen|Recevoir 120 pièces|Receber 120 moedas
A cozy home,\none step at a time.|Ein gemütliches Zuhause,\nSchritt für Schritt.|Un nid douillet,\npas à pas.|Um lar aconchegante,\num passo de cada vez.
Welcome a hen|Ein Huhn begrüßen|Accueillir une poule|Receber uma galinha
Space for %d hens|Platz für %d Hühner|Place pour %d poules|Espaço para %d galinhas
Add hen · %d coins|Huhn holen · %d Münzen|Ajouter une poule · %d pièces|Adicionar galinha · %d moedas
Expand the coop to welcome more hens.|Erweitere den Stall für mehr Hühner.|Agrandissez le poulailler pour accueillir plus de poules.|Amplie o galinheiro para receber mais galinhas.
Coop expansion|Stallerweiterung|Agrandir le poulailler|Ampliar o galinheiro
Soft nesting beds|Weiche Nester|Des nids douillets|Ninhos macios
Bigger grain store|Größerer Kornspeicher|Un plus grand grenier|Depósito de grãos maior
Each level adds space for 3 hens and 24 eggs in the nest.|Jede Stufe bietet Platz für 3 weitere Hühner und 24 Eier im Nest.|Chaque niveau ajoute une place pour 3 poules et 24 œufs dans le nid.|Cada nível adiciona espaço para 3 galinhas e 24 ovos no ninho.
Each level adds a quarter of the original laying speed.|Jede Stufe steigert die ursprüngliche Legegeschwindigkeit um ein Viertel.|Chaque niveau ajoute un quart de la vitesse de ponte initiale.|Cada nível adiciona um quarto da velocidade de postura original.
Each level adds 80 grain to the barn and 12 to the trough.|Jede Stufe bietet Platz für 80 Korn mehr in der Scheune und 12 im Trog.|Chaque niveau ajoute 80 grains à la grange et 12 à la mangeoire.|Cada nível adiciona espaço para 80 grãos no celeiro e 12 no comedouro.
Requires the first coop expansion|Benötigt die erste Stallerweiterung|Nécessite le premier agrandissement du poulailler|Requer a primeira ampliação do galinheiro
Fully grown|Voll ausgebaut|Au maximum|Ampliação completa
Improve · %d coins|Ausbauen · %d Münzen|Améliorer · %d pièces|Melhorar · %d moedas
Gentle reminders|Sanfte Erinnerungen|Des rappels tout doux|Lembretes suaves
Choose reminders for a full nest, an empty trough, and the start of the weekly fair. Your farm works the same if you decline.|Wähle Erinnerungen für ein volles Nest, einen leeren Trog und den Wochenmarkt. Dein Hof funktioniert auch ohne sie.|Choisissez des rappels pour le nid plein, la mangeoire vide et le début de la foire. La ferme fonctionne aussi si vous refusez.|Escolha lembretes para ninho cheio, comedouro vazio e início da feira semanal. Sua fazenda funciona igual se você recusar.
Device permission|Geräteberechtigung|Autorisation de l'appareil|Permissão do aparelho
Turn reminders off|Erinnerungen ausschalten|Désactiver les rappels|Desativar lembretes
Enable reminders|Erinnerungen aktivieren|Activer les rappels|Ativar lembretes
If permission was declined, you can change it in the device's notification settings.|Nach Ablehnung kannst du die Berechtigung in den Mitteilungseinstellungen des Geräts ändern.|En cas de refus, vous pouvez modifier ce choix dans les réglages de notifications de l'appareil.|Se a permissão foi recusada, você pode alterá-la nos ajustes de notificações do aparelho.
Your farm, your device|Dein Hof, dein Gerät|Votre ferme, votre appareil|Sua fazenda, seu aparelho
No account, purchases, advertising, analytics, or network connection. Farm progress is saved on this device and shared only with your farm widgets. Removing the app removes its farm.|Ohne Konto, Käufe, Werbung, Analysen oder Netzwerkverbindung. Der Fortschritt bleibt auf diesem Gerät und wird nur mit deinen Hofwidgets geteilt. Beim Löschen der App wird der Hof entfernt.|Sans compte, achats, publicité, analyse ni connexion réseau. La progression reste sur cet appareil et n'est partagée qu'avec vos widgets de ferme. Supprimer l'app supprime sa ferme.|Sem conta, compras, publicidade, análise de uso ou conexão de rede. O progresso fica neste aparelho e só é compartilhado com seus widgets da fazenda. Remover o app remove sua fazenda.
Your starter supplies are 3 hens, 80 farm coins, 48 stored grain, and 12 grain in the trough.|Du beginnst mit 3 Hühnern, 80 Hofmünzen, 48 Korn im Vorrat und 12 Korn im Trog.|Vous commencez avec 3 poules, 80 pièces, 48 grains en réserve et 12 dans la mangeoire.|Você começa com 3 galinhas, 80 moedas, 48 grãos guardados e 12 no comedouro.
Add a Farm Idle: Coop widget from your Home Screen or Lock Screen. Widget refresh timing is controlled by the system.|Füge ein Farm Idle: Coop Widget auf dem Home- oder Sperrbildschirm hinzu. Das System bestimmt die Aktualisierungszeit.|Ajoutez un widget Farm Idle: Coop sur l'écran d'accueil ou verrouillé. Le système gère son actualisation.|Adicione um widget Farm Idle: Coop à Tela de Início ou Bloqueio. O sistema controla quando ele é atualizado.
Start a new farm|Neuen Hof beginnen|Créer une nouvelle ferme|Começar outra fazenda
Done|Fertig|Terminé|Concluir
Replace this farm?|Diesen Hof ersetzen?|Remplacer cette ferme ?|Substituir esta fazenda?
Erase farm and restart|Hof löschen und neu beginnen|Effacer la ferme et recommencer|Apagar a fazenda e recomeçar
All hens, coins, and progress on this device will be replaced with starter supplies.|Alle Hühner, Münzen und Fortschritte auf diesem Gerät werden durch den Anfangsvorrat ersetzt.|Toutes les poules, pièces et progressions de cet appareil seront remplacées par les provisions de départ.|Todas as galinhas, moedas e progresso neste aparelho serão substituídos pelos recursos iniciais.
Farm update|Hofnachricht|Nouvelles de la ferme|Novidades da fazenda
OK|OK|OK|OK
Allowed|Erlaubt|Autorisée|Permitida
Disabled in device Settings|In den Geräteeinstellungen deaktiviert|Désactivée dans les réglages|Desativada nos Ajustes
Not requested|Nicht angefragt|Non demandée|Não solicitada
Your farm was recovered from its local backup.|Dein Hof wurde aus seiner lokalen Sicherung wiederhergestellt.|Votre ferme a été restaurée depuis sa sauvegarde locale.|Sua fazenda foi recuperada da cópia local.
The saved file could not be read. A fresh farm is open; the original file is kept on this device.|Die Speicherdatei war nicht lesbar. Ein neuer Hof ist geöffnet; die Originaldatei bleibt auf diesem Gerät.|Le fichier enregistré est illisible. Une nouvelle ferme est ouverte ; l'original reste sur cet appareil.|Não foi possível ler o arquivo salvo. Uma nova fazenda foi aberta; o original continua neste aparelho.
Saving is unavailable. Keep the app open and free some device storage.|Speichern nicht möglich. Lass die App offen und schaffe Speicherplatz auf dem Gerät.|Enregistrement impossible. Gardez l'app ouverte et libérez de l'espace sur l'appareil.|Não é possível salvar. Mantenha o app aberto e libere espaço no aparelho.
Reminders are unavailable. Your farm still works offline.|Erinnerungen sind nicht verfügbar. Dein Hof funktioniert weiterhin offline.|Les rappels sont indisponibles. Votre ferme fonctionne toujours hors ligne.|Os lembretes estão indisponíveis. Sua fazenda continua funcionando offline.
Your nest is full. Collect the eggs when you visit.|Dein Nest ist voll. Sammle die Eier bei deinem nächsten Besuch.|Votre nid est plein. Ramassez les œufs à votre prochaine visite.|Seu ninho está cheio. Recolha os ovos na próxima visita.
The trough is empty. Bring grain to keep eggs coming.|Der Trog ist leer. Fülle Korn nach, damit weiter Eier entstehen.|La mangeoire est vide. Ajoutez des grains pour produire des œufs.|O comedouro está vazio. Traga grãos para continuar produzindo ovos.
A new weekly fair is open in your farm.|Ein neuer Wochenmarkt ist auf deinem Hof eröffnet.|Une nouvelle foire de la semaine est ouverte sur votre ferme.|Uma nova feira semanal está aberta na sua fazenda.
%d hens in your farmyard|%d Hühner auf deinem Hof|%d poules dans votre cour|%d galinhas no seu quintal
Open your farm to begin.|Öffne deinen Hof, um zu beginnen.|Ouvrez votre ferme pour commencer.|Abra sua fazenda para começar.
Coop waiting: %d h|Stall wartet: %d Std.|Poulailler en attente : %d h|Galinheiro à espera: %d h
%d eggs ready|%d Eier bereit|%d œufs prêts|%d ovos prontos
Care streak|Pflegeserie|Série de soins|Sequência de cuidados
Your coop is waiting|Dein Stall wartet|Votre poulailler attend|Seu galinheiro espera
Your farmyard|Dein Bauernhof|Votre cour de ferme|Seu quintal
Your care streak, eggs, grain, and neighbor orders.|Deine Pflegeserie, Eier, Korn und Nachbaraufträge.|Votre série de soins, vos œufs, grains et commandes.|Sua sequência de cuidados, ovos, grãos e pedidos dos vizinhos.'''
strings={}
for row in rows.splitlines():
 parts=[s.replace('\\n','\n') for s in row.split('|')]
 assert len(parts)==4,parts
 strings[parts[0]]={'localizations':{loc:{'stringUnit':{'state':'translated','value':value}} for loc,value in zip(['en','de','fr','pt-BR'],parts)}}
(root/'Resources/Localizable.xcstrings').write_text(json.dumps({'sourceLanguage':'en','strings':strings,'version':'1.0'},ensure_ascii=False,indent=2))
info={'CFBundleDisplayName':{'localizations':{loc:{'stringUnit':{'state':'translated','value':name}} for loc,name in [('en','Farm Idle: Coop'),('de','Farm Idle: Coop'),('fr','Farm Idle: Coop'),('pt-BR','Farm Idle: Coop')]}}}
(root/'Resources/InfoPlist.xcstrings').write_text(json.dumps({'sourceLanguage':'en','strings':info,'version':'1.0'},ensure_ascii=False,indent=2))
print('Localized',len(strings),'strings in EN, DE, FR, PT-BR')
