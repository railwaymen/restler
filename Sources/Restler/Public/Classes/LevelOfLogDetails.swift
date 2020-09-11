import Foundation

extension Restler {
    public enum LevelOfLogDetails {
        /// No info will be logged.
        case nothing
        
        /// Default level of details.
        case concise
        
        /// Use only for getting the most precise information about request and response.
        case debug
    }
}
