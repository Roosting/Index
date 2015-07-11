import Foundation

public class SemVer {
  var major: Int = -1
  var minor: Int = -1
  var patch: Int = -1

  public class func parse(string: String) -> (String?, SemVer?) {
    let decimalCharacterSet = NSCharacterSet.decimalDigitCharacterSet()
    let scanner = NSScanner(string: string)

    var scanned: Bool
    var majorInt32: Int32 = 0
    var minorInt32: Int32 = 0
    var patchInt32: Int32 = 0

    if !scanner.scanInt(&majorInt32)             { return ("Invalid major version", nil) }
    if !scanner.scanString(".", intoString: nil) { return ("Invalid major-minor separator", nil) }
    if !scanner.scanInt(&minorInt32)             { return ("Invalid minor version", nil) }
    if !scanner.scanString(".", intoString: nil) { return ("Invalid major-minor separator", nil) }
    if !scanner.scanInt(&patchInt32)             { return ("Invalid patch version", nil) }

    let instance = SemVer(Int(majorInt32), Int(minorInt32), Int(patchInt32))

    return (nil, instance)
  }

  init(_ aMajor: Int, _ aMinor: Int, _ aPatch: Int) {
    major = aMajor
    minor = aMinor
    patch = aPatch
  }

  public var description: String {
    get {
      return "\(major).\(minor).\(patch)"
    }
  }
}

public func ==(left: SemVer, right: SemVer) -> Bool {
  return left.major == right.major &&
         left.minor == right.minor &&
         left.patch == right.patch
}

public func <(left: SemVer, right: SemVer) -> Bool {
  if left.major < right.major { return true }
  if left.major > right.major { return false }

  if left.minor < right.minor { return true }
  if left.minor > right.minor { return false }

  if left.patch < right.patch { return true }

  return false
}

public func >(left: SemVer, right: SemVer) -> Bool {
  return right < left
}
