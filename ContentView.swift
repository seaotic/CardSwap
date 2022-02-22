import SwiftUI
//Main class to do standard swift operations away from main views.
class DoOperations: NSObject, ObservableObject {
    @Published var deckOfCards:[card] = []
    @Published var playerOneDeck:[card] = []
    @Published var playerTwoDeck:[card] = []
    @Published var p1OffHand:[card] = []
    @Published var p2OffHand:[card] = []
    @Published var result:String = ""
    
    //Card struct main data type
    struct card{
        var cardName:String
        var cardImage:Image
        var suit:String
        var rank:Int
    }
    
    let suiteEndings = ["hearts", "clubs", "diamonds", "spades"]
    let names = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king", "ace"]
    func createDeck(){
        //Looping through suits and names to make all cards and append to deck
        for s in suiteEndings {
             for name in names{
                 let tempCard = card(cardName: name, cardImage: Image("\(name)_of_\(s)"), suit: s, rank: names.firstIndex(of: name)! + 2)
                 deckOfCards.append(tempCard)
            }
        }
        print(deckOfCards)
        //print all 52 cards to the print screen and show me the name, suit, rank of all 52 cards.
    }
    func dealDecks(){
        var deal = false
        deckOfCards.shuffle()
        for card in deckOfCards{
            if(deal){
                playerOneDeck.append(card)
            }else{
                playerTwoDeck.append(card)
            }
            deal.toggle()
        }
    }
    func declareWar(){
        //War logic
        for i in 0...2{
            p1OffHand.append(playerOneDeck[i])
            p2OffHand.append(playerTwoDeck[i])
            playerOneDeck.remove(at: i)
            playerTwoDeck.remove(at: i)
        }
    }
    func testCard(cardOne: card, cardTwo:card){
        //TESTING CARDS AND HANDLING IF HAVING A WAR
        if(playerOneDeck.isEmpty){
            result = "PLAYER TWO WON!"
        }
        else if(playerTwoDeck.isEmpty){
            result = "PLAYER ONE WON!"
        }
        else if(cardOne.rank > cardTwo.rank){
            if(!p1OffHand.isEmpty){
                for i in 0...2{
                    playerOneDeck.append(p1OffHand[i])
                    playerOneDeck.append(p2OffHand[i])
                }
                p1OffHand = []
                p2OffHand = []
                result = "PLAYER ONE WON THE WAR"
            }else{
                playerOneDeck.append(cardTwo)
                playerTwoDeck.remove(at: 0)
                playerOneDeck.append(playerOneDeck[0])
                playerOneDeck.remove(at: 0)
                result = "PLAYER ONE WINS"
            }
        }else if(cardTwo.rank > cardOne.rank){
            if(!p1OffHand.isEmpty){
                for i in 0...2{
                    playerTwoDeck.append(p1OffHand[i])
                    playerTwoDeck.append(p2OffHand[i])
                }
                p1OffHand = []
                p2OffHand = []
                result = "PLAYER TWO WON THE WAR"
            }else{
                playerTwoDeck.append(cardOne)
                playerOneDeck.remove(at: 0)
                playerTwoDeck.append(playerOneDeck[0])
                playerTwoDeck.remove(at: 0)
                result = "PLAYER TWO WINS"
            }
        }else{
            if (playerOneDeck.count < 4 && playerTwoDeck.count < 4){
                result = "THE ULTIMATE DRAW"
            }
            if(playerOneDeck.count < 4){
                result = "PLAYER ONE LOSES NOT ENOUGH CARDS"
            }
            else if(playerOneDeck.count < 4){
                result = "PLAYER ONE LOSES NOT ENOUGH CARDS"
            } else {
                declareWar()
                result = "WAR"
            }
        }
        /*
         op.playerOneDeck.append(op.playerOneDeck[0])
         op.playerOneDeck.remove(at: 0)
         op.playerTwoDeck.append(op.playerOneDeck[0])
         op.playerTwoDeck.remove(at: 0)
         */
    }
    override init(){

       super.init()
        
       createDeck()
        dealDecks()
    }
}

struct ContentView: View {
    @StateObject var op = DoOperations()
    @State var isTesting = false
    
    var body: some View {
        VStack {
            Text(op.result)
                .font(.title)
             
            // Player Card Button
            Button{
                isTesting.toggle()
                if(isTesting){
                    op.testCard(cardOne: op.playerOneDeck[0], cardTwo: op.playerTwoDeck[0])
                }
            } label:{
                VStack{
                    //PLAYER TWO SIDE
                    HStack{
                        Text("\(op.playerTwoDeck.count)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                            .padding()
                        //START VIEW
                        if (!isTesting){
                            Image("back")
                                .resizable()
                                .scaledToFit()
                        }
                        //PLAYING VIEW
                        else if(!op.playerTwoDeck.isEmpty){
                            op.playerTwoDeck[0].cardImage
                                .resizable()
                                .scaledToFit()
                        }else{
                            Text("YOU LOST :(")
                                .font(.largeTitle)
                        }
                        if(!op.p2OffHand.isEmpty){
                            op.p2OffHand[0].cardImage
                                .resizable()
                                .scaledToFit()
                        }
                    }.rotationEffect(.degrees(180.0))
                    // PLAYER ONE SIDE
                    HStack{
                        Text("\(op.playerOneDeck.count)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                            .padding()
                        //START VIEW
                        if(!isTesting){
                            Image("back")
                                .resizable()
                                .scaledToFit()
                        }
                        //PLAYING VIEW
                        else if(!op.playerOneDeck.isEmpty){
                            op.playerOneDeck[0].cardImage
                                .resizable()
                                .scaledToFit()
                        }else{
                            Text("YOU LOST :(")
                                .font(.largeTitle)
                        }
                        if(!op.p1OffHand.isEmpty){
                            op.p1OffHand[0].cardImage
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            
            }
            //Description of card shown
            Text("Player 1 Deck Count: \(op.playerOneDeck.count) Player 2 Deck Count: \(op.playerTwoDeck.count)").font(.subheadline)
            
            //Buttons to shuffle, re-arrange, etc. (DEV MENU)
            /*HStack{
                Button{
                    op.deckOfCards.shuffle()
                } label:{
                    Text("Shuffle Deck")
                        .font(.title)
                        .padding()
                        .background(.gray)
                        .foregroundColor(.white)
                }
                Button{
                    op.deckOfCards = []
                    op.createDeck()
                } label: {
                    Text("Re-arrange Deck")
                        .font(.title)
                        .padding()
                        .background(.gray)
                        .foregroundColor(.white)
                }
            }
            */
        }
    }
}
