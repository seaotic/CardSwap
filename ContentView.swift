import SwiftUI

class DoOperations: NSObject, ObservableObject {
    @Published var deckOfCards:[Image] = []
    
    let suiteEndings = ["hearts", "clubs", "diamonds", "spades"]
    let ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king", "ace"]
    override init(){

       super.init()
        
       for s in suiteEndings {
            for rank in ranks{
               deckOfCards.append(Image("\(rank)_of_\(s)"))
           }
       }
     }
    
}

struct ContentView: View {
    @StateObject var op = DoOperations()
    
    var body: some View {
        VStack {
            op.deckOfCards[0]
                .imageScale(.large)
            
            Button {
                op.deckOfCards.append(op.deckOfCards[0])
                op.deckOfCards.remove(at: 0)
            } label: {
                Text("Flip Images")
            }
            
        }
    }
}
