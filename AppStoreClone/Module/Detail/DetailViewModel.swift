//
//  DetailViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import RxCocoa
import RxSwift

typealias DetailViewModelInput = (firstInput: AnyObserver<Void>,
                                    secondInput: AnyObserver<Void>)
typealias DetailViewModelOutput = (datasource: Driver<[DetailSection]>,
                                     secondOutput: Observable<Void>)

protocol DetailViewModelType {
    var input: DetailViewModelInput { get }
    var output: DetailViewModelOutput { get }
}

final class DetailViewModel: DetailViewModelType {
    
    private let disposeBag = DisposeBag()
    
    // MARK: INPUT
    private let firstInput = PublishSubject<Void>()
    private let secondInput = PublishSubject<Void>()
    
    var input: DetailViewModelInput {
        return (firstInput.asObserver(),
                secondInput.asObserver())
    }
    
    // MARK: OUTPUT
    private let datasource = BehaviorRelay<[DetailSection]>(value: [])
    private let secondOutput = PublishSubject<Void>()
    
    var output: DetailViewModelOutput {
        return (datasource: datasource.asDriver(onErrorJustReturn: []),
                secondOutput: secondOutput.asObserver())
    }
    
    init(data: Result) {
        let titleSection = DetailSection(type: .title, items: [
            TitleItem(thumbNail: data.artworkUrl512,
                      title: data.trackName,
                      subTitle: data.description,
                      isDownload: false)
        ])
        
        let briefInfoSection = DetailSection(type: .briefInfo, items: [
            BriefInfoItem(type:
                    .grade(GradeInfo(total: 4.7,
                                     score: 4.6))),
            BriefInfoItem(type: .age(AgeInfo(age: "4+"))),
            BriefInfoItem(type: .chart(ChartInfo(rank: 24,
                                                 type: "액션"))),
            BriefInfoItem(type: .developer(DeveloperInfo(id: "wi-seong"))),
            BriefInfoItem(type: .language(LanguageInfo(language: "KO",
                                                       total: 12)))
        ])
        
        guard let previewURLs = data.screenshotUrls else {
            print("잘못된 URL입니다.")
            return
        }
        let previewSection = DetailSection(type: .preview, items:
            previewURLs.map {
                PreviewItem(content: .photo(ScreenShot(url: $0)))
            }
        )
         
        let explanationSection = DetailSection(type: .explanation, items: [
            ExplanationItem(description: data.description)
        ])
        
        let developerSection = DetailSection(type: .developer, items: [
            DeveloperItem(developerID: data.sellerName)
        ])
        
        let eventSection = DetailSection(type: .event, items: [
            EventItem(time: "(목) 오후 7:00",
                      thumbnail: "https://res09.bignox.com/appcenter/kr/2020/01/%ED%81%AC%EA%B8%B0%EB%B3%80%ED%99%98%ED%86%A0%ED%82%B9%ED%86%B0-%EA%B3%A8%EB%93%9C%EB%9F%B0-%EB%B0%B0%EA%B2%BD.jpg")
        ])
        
        datasource.accept([
            titleSection,
            briefInfoSection,
            previewSection,
            explanationSection,
            developerSection,
//            eventSection,
            
            DetailSection(type: .evauation, items: [
                EvaluationItem(grade: 4.5,
                               five: 0.88,
                               four: 0.1,
                               three: 0.01,
                               two: 0.01,
                               one: 0.1,
                               total: 10989)
            ]),
            
            DetailSection(type: .review, items: [
                ReviewItem(title: "Text",
                           date: "1년 전",
                           nickname: "향기",
                           review: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                           grade: 5),
                ReviewItem(title: "Text",
                           date: "1년 전",
                           nickname: "향기",
                           review: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500sLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                           grade: 5),
                ReviewItem(title: "Text",
                           date: "1년 전",
                           nickname: "향기",
                           review: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                           grade: 5)
            ]),
            
            DetailSection(type: .feature, items: [
                FeatureItem(version: "버전 12.1.26",
                            date: "2일 전",
                            content: "y dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy ")
            ]),
            
            DetailSection(type: .privacy, items: [
                PrivacyItem(title: "y dummy text of the pr",
                            content: "y dummy text of the printing and typesetting mmy text of the printing and typesettingmmy text of the printing and typesettingindustry. Lorem Ipsum has been the industry's standard dummy "),
                PrivacyItem(title: "y dummy text of the pr",
                            content: "y dummy text of ts been the industry's standard dummy ")
            ]),
            
            DetailSection(type: .relation, items: [
                RelationItem(appIcon:   "https://images.applypixels.com/images/originals/1696b13e-7eb7-4fd0-83a1-bb89d5aa5ab8.png",
                             title: "abc",
                             desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
                RelationItem(appIcon:   "https://images.applypixels.com/images/originals/1696b13e-7eb7-4fd0-83a1-bb89d5aa5ab8.png",
                             title: "abc",
                             desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
                RelationItem(appIcon:   "https://images.applypixels.com/images/originals/1696b13e-7eb7-4fd0-83a1-bb89d5aa5ab8.png",
                             title: "abc",
                             desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
            ]),
            
            DetailSection(type: .likable, items: [
                LikableItem(appIcon:   "https://images.applypixels.com/images/originals/1696b13e-7eb7-4fd0-83a1-bb89d5aa5ab8.png",
                            title: "abc",
                            desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
                LikableItem(appIcon:   "https://images.applypixels.com/images/originals/1696b13e-7eb7-4fd0-83a1-bb89d5aa5ab8.png",
                            title: "abc",
                            desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
                LikableItem(appIcon:   "https://images.applypixels.com/images/originals/1696b13e-7eb7-4fd0-83a1-bb89d5aa5ab8.png",
                            title: "abc",
                            desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
            ])
        ])
    }
}
