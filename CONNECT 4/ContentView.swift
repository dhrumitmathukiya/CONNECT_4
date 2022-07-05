//
//  ContentView.swift
//  CONNECT 4
//
//  Created by mac on 23/06/22.
//

import SwiftUI

struct ContentView: View {
   @State var data = Array(repeating: Array(repeating: 0, count: 7), count: 6)
    @State var gameOver:Bool = false
    @State var newGame:Bool = false
    @State var winningArray:[String] = []
    let arr:[Color] = [Color(#colorLiteral(red: 0.8885620236, green: 0.9107806087, blue: 0.05555932969, alpha: 1)),Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)),Color(#colorLiteral(red: 0.1618428826, green: 0.586560905, blue: 0.9304246306, alpha: 1))]
    @State var anyWon:Int = 0
    @State var showAlert:Bool = false
    @State var reset:Bool = false
    @State var dataChange:Bool = false
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),Color(#colorLiteral(red: 0.4578455091, green: 0.08123516291, blue: 0.3945105076, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack{
                Spacer()
                ForEach (0..<6){ i in
                    HStack{
                        ForEach (0..<7){ j in
                            Button {
                                self.dataChange.toggle()
                                   gravityCheck(row: i, colum: j)
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                .overlay(
                                    ZStack{
                                        arr[data[i][j]]
                                        if winningArray.contains("\(i)\(j)"){
                                             Text("X")
                                            .font(Font.system(size: 50,weight: .semibold))
                                            .foregroundColor(.white)
                                            
                                        }
                                            
                                    }
                                )
                                    .frame(width: 45, height: 60)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
                Button {
                    self.reset.toggle()
                    winningArray = []
                    resetGame()
                } label: {
                    Text("RESET")
                        .frame(width: 100, height: 50)
                        .foregroundColor(.black)
                        .background(.yellow)
                        .cornerRadius(20)
                        .padding(120)
                }
            }.alert(isPresented: $showAlert, content: {
                Alert(title: Text("ALL SQARES ARE FULL !!!"),
                      message: Text("DO YOU WANT TO RESTART THIS GAME??"),
                      primaryButton: .default(Text("OK"),action: {
                    winningArray = []
                    resetGame()
                }),
                      secondaryButton: .cancel())
            })
        }
    }
    func checkWinner(row:Int,colum:Int){
        var masterArray:[[Int]] = []
        var answerArray:[Int] = []
        var indexArray:[[String]] = []
        var microIndex:[String] = []
        //code for row
        for i in 0...data.count-1{
            for j in 0...data[0].count-1{
                if row == i{
                    answerArray.append(data[i][j])
                    microIndex.append("\(i)\(j)")
                }
            }
        }
        masterArray.append(answerArray)
        answerArray = []
        indexArray.append(microIndex)
        microIndex = []
        // code for colum
        for x in 0...data[0].count-1{
            for y in 0...data.count-1{
                if colum == x{
                    answerArray.append(data[y][x])
                    microIndex.append("\(y)\(x)")
                }
            }
        }
        masterArray.append(answerArray)
        answerArray = []
        indexArray.append(microIndex)
        microIndex = []
        // new code front cross
        let diffrence = abs(row - colum)
        var count = 0
        let start: Int
        if row > colum{
            start = diffrence
        }
        else{
            start = 0
            count = diffrence
        }
        for x in start..<data.count{
            if count < data[0].count{
                answerArray.append(data[x][count])
                microIndex.append("\(x)\(count)")
            }
            count += 1
        }
        masterArray.append(answerArray)
        answerArray = []
        indexArray.append(microIndex)
        microIndex = []
        
        // new code back cross
        var newCount = 6
        var newstart: Int = 0
        if row + colum >= 6 {
            newstart = abs(6 - colum - row)
        } else {
            newCount = row + colum
        }
        for y in newstart..<data.count{
            if newCount >= 0 {
                answerArray.append(data[y][newCount])
                microIndex.append("\(y)\(newCount)")
                newCount -= 1
            }
        }
        masterArray.append(answerArray)
        answerArray = []
        indexArray.append(microIndex)
        microIndex = []
        
        

        for i in masterArray{
            if i.count >= 4{
                let dataSet = checkSet(check:i)
                self.reset.toggle()
                if dataSet != 0{
                    let index = masterArray.firstIndex(of: i)
                    winningArray = checkSetIndex(check: indexArray[index!], winner: dataSet)
                    anyWon = dataSet
                    showAlert.toggle()
                    break
                }
            }
        }
        var result = false
        for i in 0..<data.count{
            if data[i].contains(0){
                result = true
                break
            }
        }
        if !result{
            showAlert = true
        }
    }

    func checkSet(check:[Int]) -> Int {
        for i in 0..<check.count - 3{
            let setchek = Set(check[i..<i+4])
            if setchek.count == 1, let first = setchek.first, first != 0{
                return first
            }
        }
        return 0
    }
    
    func checkSetIndex(check:[String], winner: Int) -> [String] {
        var winningIndex:[String] = []
        var counter = 0
        for index in check{
            let array = Array(index).map({ Int(String($0)) ?? 0 })
            let i = array[0]
            let j = array[1]
            if data[i][j] != 0 && counter <= 4{
                counter += 1
                winningIndex.append("\(i)\(j)")
            }
            else {
                counter = 0
                winningIndex = []
            }
        }
         return winningIndex
    }
    
    func resetGame(){
       data = [[0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0]]
    }
    
    func gravityCheck(row:Int,colum:Int){
        let ndata = data[0].indices.map{col in
            data.indices.map {row in
                data[row][col]
            }
        }
        let lk =  ndata[colum]
        if let jkl = lk.lastIndex(of: 0) {
            data[jkl][colum] = dataChange ? 1 : 2
            checkWinner(row: jkl, colum: colum)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
