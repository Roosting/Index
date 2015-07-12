import Foundation
import SemVer
import Yaml

let fileManager = NSFileManager.defaultManager()

struct Version {
  var version: SemVer
  var descriptor: AnyObject
}

class Package {

  // From package's Roostfile.yaml
  var name: String

  // From package's Metadata.yaml
  var versions: [Version]
  
  init(name: String, versions: [Version]) {
    self.name     = name
    self.versions = versions
  }

  

// Class functions

  class func loadByName(name: String) -> Package {
    let roostfilePath = "packages/\(name)/Roostfile.yaml"
    let metadataPath  = "packages/\(name)/Metadata.yaml"

    if fileManager.fileExistsAtPath(metadataPath) {
      // TODO: Implement me!
    }

    if !fileManager.fileExistsAtPath(roostfilePath) {
      printAndExit("Missing \(roostfilePath)")
    }

    let roostfileName = parseRoostfile(readFile(roostfilePath))

    assert(roostfileName == name, "Roostfile.yaml's name doesn't equal directory name (\(name))")

    return Package(name: roostfileName, versions: [Version]())
  }

  private class func parseRoostfile(contents: String) -> (String) {
    let result = Yaml.load(contents)

    if let error = result.error {
      printAndExit(error)
    }

    let roostfile = result.value!
    let name = roostfile["name"].string!

    return name
  }

  class func scanPackagesDirectory() -> [String] {
    var packages = [String]()
    var error: NSError?

    let contents = fileManager.contentsOfDirectoryAtPath("Packages", error: &error)

    if error != nil {
      printAndExit(error!.description)
    }

    for anyContent in contents! {
      let content = anyContent as! NSString

      packages.append(content as String)
    }

    return packages
  }

}// class Package
