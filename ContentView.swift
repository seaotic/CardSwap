import SwiftUI
//Main class to do standard swift operations away from main views.
class DoOperations: NSObject, ObservableObject {
    @Published var deckOfCards:[card] = []
    @Published var playerOneDeck:[card] = []
    @Published var playerTwoDeck:[card] = []
    @Published var p1OffHand:[card] = []
    @Published var p2OffHand:[card] = []
    @Published var result:String = "READY TO START?"
    @Published var p1BeforeCard:card?
    @Published var p2BeforeCard:card?
    
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
        //var deal = false
        //deckOfCards.shuffle()
        /*
        for card in deckOfCards{
            if(deal){
                playerOneDeck.append(card)
            }else{
                playerTwoDeck.append(card)
            }
            deal.toggle()
        }
         */
        for __ in 0...25{
            playerOneDeck.append(deckOfCards[0])
            deckOfCards.remove(at: 0)
        }
        for __ in 0...25{
            playerTwoDeck.append(deckOfCards[0])
            deckOfCards.remove(at: 0)
        }
        print(deckOfCards.count)
    }
    func declareWar(){
        //War logic
        print(playerOneDeck)
        for i in 0...2{
            p2OffHand.append(playerTwoDeck[i])
            p1OffHand.append(playerOneDeck[i])
            playerTwoDeck.remove(at: 0)
            playerOneDeck.remove(at: 0)
            
        }
        print(p2OffHand)
        print(p1OffHand)
    }
    func testCard(cardOne: card, cardTwo:card){
        //SHOW THE CARDS THAT ARE BEING TESTED !!!!!!!!!
        p1BeforeCard = cardOne
        p2BeforeCard = cardTwo
        
        //TESTING CARDS AND HANDLING IF HAVING A WAR
        
        //WINS
        if(playerOneDeck.isEmpty){
            result = "PLAYER TWO WON!"
        }
        else if(playerTwoDeck.isEmpty){
            result = "PLAYER ONE WON!"
        }
        //PLAYER ONE WON
        else if(cardOne.rank > cardTwo.rank){
            result = "PLAYER ONE WINS"
            //IF THERE IS A TIE AND THE HANDLIND OF THE OFF HAND ON PLAYER TWO WIN
            if(!p1OffHand.isEmpty){
                result = "PLAYER ONE WON THE WAR"
                for i in 0...2{
                    playerOneDeck.append(p1OffHand[i])
                    playerOneDeck.append(p2OffHand[i])
                }
                p1OffHand = []
                p2OffHand = []
                
            }else{
                //NORMAL SITUATION PLAYER ONE WINS
                playerOneDeck.append(cardTwo)
                playerTwoDeck.remove(at: 0)
                playerOneDeck.append(playerOneDeck[0])
                playerOneDeck.remove(at: 0)
            }
        //PLAYER 2 WON
        }else if(cardTwo.rank > cardOne.rank){
            
            //IF THERE IS A TIE AND THE HANDLIND OF THE OFF HAND ON PLAYER TWO WIN
            result = "PLAYER TWO WINS"
            if(!p1OffHand.isEmpty){
                result = "PLAYER TWO WON THE WAR"
                for i in 0...2{
                    playerTwoDeck.append(p1OffHand[i])
                    playerTwoDeck.append(p2OffHand[i])
                }
                p1OffHand = []
                p2OffHand = []
                
            }else{
                //NORMAL SITUATION PLAYER TWO WINS
                playerTwoDeck.append(cardOne)
                playerOneDeck.remove(at: 0)
                playerTwoDeck.append(playerOneDeck[0])
                playerTwoDeck.remove(at: 0)
            }
        }else{
            //TIES
            //INFINITE TIE LOOP
            if (playerOneDeck.count < 4 && playerTwoDeck.count < 4){
                result = "THE ULTIMATE DRAW"
            }
            //PLAYER ONE RAN OUT OF CARDS
            else if(playerOneDeck.count < 4){
                result = "PLAYER ONE LOSES NOT ENOUGH CARDS"
            }
            //PLAYER TWO RAN OUT OF CARDS
            else if(playerOneDeck.count < 4){
                result = "PLAYER ONE LOSES NOT ENOUGH CARDS"
            } else {
                //IF THERE IS A WAR HANDLING
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
        print(playerTwoDeck)
        print(playerOneDeck)
    }
}

struct ContentView: View {
    @StateObject var op = DoOperations()
    @State var isTesting = false
    
    var body: some View {
        VStack {
            
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
                            op.p2BeforeCard?.cardImage
                                .resizable()
                                .scaledToFit()
                        }else{
                            Text("YOU LOST :(")
                                .font(.largeTitle)
                        }
                        //OFF HAND VISUALS
                        if(!op.p2OffHand.isEmpty){
                             ZStack{
                                 Image("back")
                                     .resizable()
                                     .scaledToFit()
                                 Image("back")
                                     .resizable()
                                     .scaledToFit()
                                     .rotationEffect(.degrees(5.0))
                                 Image("back")
                                     .resizable()
                                     .scaledToFit()
                                     .rotationEffect(.degrees(10.0))
                            }
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
                            op.p1BeforeCard?.cardImage
                                .resizable()
                                .scaledToFit()
                        }else{
                            Text("YOU LOST :(")
                                .font(.largeTitle)
                        }
                        //OFF HAND VISUALS
                       if(!op.p1OffHand.isEmpty){
                            ZStack{
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(.degrees(5.0))
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(.degrees(10.0))
                                }
                       }
                }
                    
            }
            //Description of card shown
            //Text("Player 1 Deck Count: \(op.playerOneDeck.count) Player 2 Deck Count: \(op.playerTwoDeck.count)").font(.subheadline)
            
            //Buttons to shuffle, re-arrange, etc. (OLD DEBUG MENU)
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
            Text(op.result)
                .font(.title)
    }
}
}
