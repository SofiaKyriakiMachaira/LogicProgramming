Παραλλαγή της εξής άσκησης:

Έστω ότι δίνονται τα παρακάτω γεγονότα Prolog:
activity(1, act(0,3)). activity(2, act(0,4)). activity(3, act(1,5)).
activity(4, act(4,6)). activity(5, act(6,8)). activity(6, act(6,9)).
activity(7, act(9,10)). activity(8, act(9,13)). activity(9, act(11,14)).
Τα γεγονότα activity/2 κωδικοποιούν δραστηριότητες που θα πρέπει να στελεχωθούν από
άτομα. Κάθε γεγονός activity(<AId>, act(<Start>,<End>)) σημαίνει ότι η δραστηριότητα
<AId> αρχίζει τη χρονική στιγμή <Start> και τελειώνει τη χρονική στιγμή <End>. Υποθέστε
ότι κάθε δραστηριότητα πρέπει να στελεχωθεί από ένα ακριβώς άτομο και ότι κάθε άτομο μπορεί
να αναλάβει οσεσδήποτε δραστηριότητες, αρκεί να ισχύει ο περιορισμός ότι όχι μόνο δεν μπορεί
ένα άτομο να αναλάβει δύο δραστηριότητες που επικαλύπτονται χρονικά, αλλά θα πρέπει μεταξύ δύο οποιωνδήποτε διαδοχικών δραστηριοτήτων κάθε ατόμου να μεσολαβεί τουλάχιστον μία
μονάδα χρόνου. Το ζητούμενο είναι να ορίσουμε σε Prolog ένα κατηγόρημα assignment/2, το
οποίο, όταν καλείται ως assignment(<NPersons>, <Assignment>), όπου <NPersons> είναι
το πλήθος των διαθέσιμων ατόμων, να αναθέτει τις δοθείσες δραστηριότητες στα δοθέντα άτομα
με εϕικτό τρόπο, επιστρέϕοντας στη μεταβλητή <Assignment> τις αναθέσεις με κατάλληλη κωδικοποίηση, για παράδειγμα σαν μία λίστα από στοιχεία της μορϕής <AId>-<PId>, που σημαίνουν
ότι η δραστηριότητα <AId> ανατίθεται στο άτομο <PId>. Το κατηγόρημα assignment/2 θα
πρέπει να επιστρέϕει όλες τις εϕικτές λύσεις μέσω οπισθοδρόμησης. Συμπληρώστε κατάλληλα
το παρακάτω ημιτελές πρόγραμμα ώστε να υλοποιεί το ζητούμενο.
assignment(NPersons, Assignment) :-
.................................., % Gather all activities in list AIds
assign(AIds, NPersons, Assignment).
assign([], _, []).
assign([AId|AIds], NPersons, [AId-PId|Assignment]) :-
assign(AIds, NPersons, Assignment),
.................................., % Select a person PId for activity AId
activity(AId, act(Ab, Ae)),
.................................., % Gather in list APIds so far activities of PId
valid(Ab, Ae, APIds). % Is current assignment consistent with previous ones?
valid(_, _, []).
valid(Ab1, Ae1, [APId|APIds]) :-
activity(APId, act(Ab2, Ae2)),
..................................,
valid(Ab1, Ae1, APIds).
..................................... % Definitions of possible auxiliary predicates
Κάποια παραδείγματα εκτέλεσης:
?- assignment(3, Assignment).
Assignment = [1 - 2, 2 - 3, 3 - 1, 4 - 2, 5 - 1, 6 - 3, 7 - 1, 8 - 2, 9 - 1] --> ;
Assignment = [1 - 2, 2 - 1, 3 - 3, 4 - 2, 5 - 1, 6 - 3, 7 - 1, 8 - 2, 9 - 1] --> ;
.....................................
?- assignment(2, Assignment).
No
?- findall(Assignment, assignment(3, Assignment), Assignments), length(Assignments, N).
.....................................
N = 48
