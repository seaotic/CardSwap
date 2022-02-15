import SwiftUI

class DoOperations: NSObject, ObservableObject {
    @Published var deckOfCards:[card] = []
    struct card{
        var cardName:String
        var cardImage:Image
        var suit:String
        var rank:Int
    }
    
    let suiteEndings = ["hearts", "clubs", "diamonds", "spades"]
    let names = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king", "ace"]
    func createDeck(){
        for s in suiteEndings {
             for name in names{
                 let tempCard = card(cardName: name, cardImage: Image("\(name)_of_\(s)"), suit: s, rank: names.firstIndex(of: name)! + 2)
                 deckOfCards.append(tempCard)
            }
        }
        //print all 52 cards to the print screen and show me the name, suit, rank of all 52 cards.
    }
    override init(){

       super.init()
        
       createDeck()
    }
}

struct ContentView: View {
    @StateObject var op = DoOperations()
    
    var body: some View {
        VStack {
            
            Button {
                op.deckOfCards.append(op.deckOfCards[0])
                op.deckOfCards.remove(at: 0)
            } label: {
                op.deckOfCards[0].cardImage
                    .imageScale(.large)
            }
            Text("Card Name: \(op.deckOfCards[0].cardName), Card Suit: \(op.deckOfCards[0].suit), Card IndexPower: \(op.deckOfCards[0].rank)").font(.subheadline)
            HStack{
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
            
        }
    }
}
