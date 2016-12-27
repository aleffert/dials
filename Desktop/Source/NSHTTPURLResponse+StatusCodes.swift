//
//  NSHTTPURLResponse+Status Codes.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/3/15.
//
//

import Foundation

extension HTTPURLResponse {
    var statusCodeDescription : String {
        switch statusCode {
            case 100: return "Continue"
            case 101: return "Switching Protocols"
            case 102: return "Processing"
            
            // Success
            case 200: return "OK"
            case 201: return "Created"
            case 202: return "Accepted"
            case 203: return "Non Authoritative Information"
            case 204: return "No Content"
            case 205: return "Reset Content"
            case 206: return "Partial Content"
            case 207: return "Multi Status"
            case 208: return "Already Reported"
            case 209: return "IM Used"
            
            // Redirection
            case 300: return "Multiple Choices"
            case 301: return "Moved Permanently"
            case 302: return "Found"
            case 303: return "See Other"
            case 304: return "Not Modified"
            case 305: return "Use Proxy"
            case 306: return "Switch Proxy"
            case 307: return "Temporary Redirect"
            case 308: return "Permanent Redirect"
            
            // Failure
            case 400: return "Bad Request"
            case 401: return "Unauthorized"
            case 402: return "Payment Required"
            case 403: return "Forbidden"
            case 404: return "Not Found"
            case 405: return "Method Not Allowed"
            case 406: return "Not Acceptable"
            case 407: return "Proxy Authentication Required"
            case 408: return "Request Timeout"
            case 409: return "Conflict"
            case 410: return "Gone"
            case 411: return "Length Required"
            case 412: return "Precondition Failed"
            case 413: return "Request Entity Too Large"
            case 414: return "Request URI Too Long"
            case 415: return "Unsupported Media Type"
            case 416: return "Requested Range Not Satisfiable"
            case 417: return "Expectation Failed"
            case 418: return "I Am a Teapot"
            case 419: return "Authentication Timeout"
            case 420: return "Enhance Your Calm Twitter"
            case 422: return "Unprocessable Entity"
            case 423: return "Locked"
            case 424: return "Failed Dependency"
            case 424: return "Method Failure Web Daw"
            case 425: return "Unordered Collection"
            case 426: return "Upgrade Required"
            case 428: return "Precondition Required"
            case 429: return "Too Many Requests"
            case 431: return "Request Header Fields Too Large"
            case 444: return "No Response Nginx"
            case 449: return "Retry With Microsoft"
            case 450: return "Blocked By Windows Parental Controls"
            case 451: return "Redirect Microsoft"
            case 451: return "Unavailable For Legal Reasons"
            case 494: return "Request Header Too Large Nginx"
            case 495: return "Cert Error Nginx"
            case 496: return "No Cert Nginx"
            case 497: return "HTTP To HTTPS Nginx"
            case 499: return "Client Closed Request Nginx"
            
            // Server error
            case 500: return "Internal Server Error"
            case 501: return "Not Implemented"
            case 502: return "Bad Gateway"
            case 503: return "Service Unavailable"
            case 504: return "Gateway Timeout"
            case 505: return "HTTPVersion Not Supported"
            case 506: return "Variant Also Negotiates"
            case 507: return "Insufficient Storage"
            case 508: return "Loop Detected"
            case 509: return "Bandwidth Limit Exceeded"
            case 510: return "Not Extended"
            case 511: return "Network Authentication Required"
            case 522: return "Connection Timed Out"
            case 598: return "Network Read Timeout Error Unknown"
            case 599: return "Network Connect Timeout Error Unknown"

            default: return "Unknown"
        }
    }
}
