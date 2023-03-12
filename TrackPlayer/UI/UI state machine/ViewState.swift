//
//  ViewState.swift
//  Portable
//

import Foundation

/// Состояния UI стейт машины
enum ViewState<T> {
    
    case content(T, ContentState)   // отображается контент, связанные значения - контент и подсостояние отображения контента
    case loading                    // идет загрузка контента
    case error(Error?)              // отображается ошибка загрузки контента, связанное значение - опциональные данные об ошибке
    case empty                      // контент отсутствует
    
    /// Является ли состоянием, отображающим загрузку поверх контента
    var isContentStateAndLoadingSubstate: Bool {
        switch self {
        case .content(_, .loading):
            return true
        default:
            return false
        }
    }
}

/// Подсостояние отображения контента
enum ContentState {
    
    case `default`       // контент отображается
    case pullToRefresh   // идет обновление контента через pullToRefresh
    case infinityScroll  // идет подгрузка дополнительного контента
    case loading         // отображается загрузка поверх контента
    case error(Error?)   // отображается ошибка поверх контента, связанное значение - опциональные данные об ошибке
    
    /// Является ли состоянием, отображающим загрузку
    var isLoadingState: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    /// Является ли состоянием, отображающим ошибку
    var isErrorState: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
    
    /// Ошибка, связанная с состоянием (если есть)
    var error: Error? {
        switch self {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
}
