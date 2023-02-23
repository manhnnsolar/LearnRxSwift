//
//  ViewController.swift
//  LearnRx
//
//  Created by Manh Nguyen Ngoc on 23/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        learnObservableSequences()
        learnPublishSubject()
        learnBehaviourSubject()
        learnReplaySubject()
        learnMerger()
        learnConcat()
        learnStartWith()
        learnMap()
        learnFlatMap()
        learnFlatMapLatest()
        learnElementAt()
        learnFilter()
        learnTake()
        learnTakeWhile()
        learnTakeUntil()
    }

    private func learnObservableSequences() {
        print("\nObservableSequences \n")
        
        let helloSequence = Observable.just("Hello Babay")
        let fibonaciSequence = Observable.from([0, 1, 1, 2, 3, 5, 8])
        let dictSequence = Observable.from([1: "Come on", 2: "Boy"])
        
        let subscription = helloSequence.subscribe { textEvent in
            print(textEvent)
        }.disposed(by: disposeBag)
    }
    
    private func learnPublishSubject() {
        print("\nPublishSubject \n")
        
        let subject = PublishSubject<String>()
        
        subject.onNext("element 1")
        
        subject.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
        subject.onNext("element 2")
    }
    
    private func learnBehaviourSubject() {
        print("\nBehaviourSubject \n")
        
        let subject = BehaviorSubject(value: "Value 0")
        
        subject.onNext("Value 1")
        
        subject.subscribe(onNext: { event in
            print(event)
        }).disposed(by: disposeBag)
        
        subject.onNext("Value 2")
    }
    
    private func learnReplaySubject() {
        print("\nReplaySubject \n")
        
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        
        replaySubject.onNext("Issue 1")
        replaySubject.onNext("Issue 2")
        replaySubject.onNext("Issue 3")
        replaySubject.onNext("Issue 4")
        replaySubject.onNext("Issue 5")
        
        replaySubject.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
        replaySubject.onNext("Issue 6")
        replaySubject.onNext("Issue 7")
        replaySubject.onNext("Issue 8")
    }
    
    private func learnMerger() {
        print("\nMerger \n")
        
        let left = PublishSubject<Int>()
        let right = PublishSubject<Int>()
        
        let source = Observable.of(left.asObserver(), right.asObserver())
        let obserable = source.merge()
        
        obserable.subscribe(onNext: { event in
            print(event)
        }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
        
        left.onNext(1)
        right.onNext(4)
        left.onNext(2)
        left.onNext(3)
        right.onNext(5)
        right.onNext(6)
    }
    
    private func learnConcat() {
        print("\nConcat \n")
        
        let left = PublishSubject<Int>()
        let right = PublishSubject<Int>()
        
        let observable = Observable.concat([left, right])
        observable.subscribe(onNext: { event in
            print(event)
        }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
        
        left.onNext(1)
        right.onNext(4)
        left.onNext(2)
        left.onNext(3)
        right.onNext(5)
        right.onNext(6)
    }
    
    private func learnStartWith() {
        print("\nStartWith \n")
        
        let number = Observable.of(4, 5, 6)
        let obserable = number.startWith(1, 2, 3)
        obserable.subscribe(onNext: { event in
            print(event)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    private func learnMap() {
        print("\nMap \n")
        
        let observable = Observable.of(1, 2, 3)
        
        observable.map {
            return $0 * 2
        }.subscribe(onNext: { event in
            print(event)
        }).disposed(by: disposeBag)
    }
    
    private func learnFlatMap() {
        print("\nFlatMap \n")
        
        struct Player {
            var score: BehaviorRelay<Int>
        }
        
        let kevin = Player(score: BehaviorRelay(value: 50))
        let player = PublishSubject<Player>()
        
        player.asObservable().flatMap {
            $0.score.asObservable()
        }.subscribe(onNext: { event in
            print(event)
        }).disposed(by: disposeBag)
        
        player.onNext(kevin)
    }
    
    private func learnFlatMapLatest() {
        print("\nFlatMapLatest \n")
        
        let outerObservable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance).take(2)
        let combineObservable = outerObservable.flatMapLatest {  value in
            return Observable<NSInteger>.interval(0.3, scheduler: MainScheduler.instance).take(3).map {  inerValue in
              print("Outer value \(value) Iner Value \(inerValue)")
            }
        }
              
        combineObservable.subscribe(onNext: { (event) in
            print("event \(event)")
        }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
    }
    
    private func learnElementAt() {
        print("\nElementAt \n")
        
        let observable1 = Observable.of(1,2,3)

        observable1.elementAt(1).subscribe(onNext: { (event) in
            print("ElementAt: \(event)")
        }).disposed(by: disposeBag)
    }
    
    private func learnFilter() {
        print("\nFilter \n")
        
        let observable1 = Observable.of(1,2,3,4,5,6)
              
        observable1.filter { $0 % 2 == 0
        }.subscribe(onNext: { (event) in
            print("Filter \(event)")
        }).disposed(by: disposeBag)
        
        let observable2 = Observable.of("A","B","C","D","E","F")
          
        observable2.skip(0).skip(4).subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    private func learnTake() {
        print("\nTake \n")
        
        let observable3 = Observable.of("A","B","C","D","E","F")
          
        observable3.take(3).subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    private func learnTakeWhile() {
        Observable.of(2,4,6,7,5,8,10).takeWhile {
            return $0 % 2  == 0
        }.subscribe(onNext: { (event) in
            print(event)
        }).disposed(by: disposeBag)
    }
    
    private func learnTakeUntil() {
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()
        
        subject.takeUntil(trigger).subscribe(onNext: { (event) in
            print(event)
        }).disposed(by: disposeBag)
        
        subject.onNext("event 1")
        trigger.onNext("X")
        subject.onNext("event 2")
        trigger.onNext("event 3")
    }
}
