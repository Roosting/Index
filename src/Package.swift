import Foundation
import SemVer
import Yaml

let fileManager = NSFileManager.defaultManager()

struct Version {
  var version: SemVer
  var description: String
}

class Package {

  // From package's Roostfile.yaml
  var name: String
  var version: SemVer // Current version of the package

  // From package's Metadata.yaml
  var versions: [Version]

  init(name: String, version: SemVer, versions: [Version]) {
    self.name     = name
    self.version  = version
    self.versions = versions
  }



// Class functions

  class func loadByName(name: String) -> Package {
    let roostfilePath = "packages/\(name)/Roostfile.yaml"
    let metadataPath  = "packages/\(name)/Metadata.yaml"

    if !fileManager.fileExistsAtPath(metadataPath) {
      printAndExit("Missing \(metadataPath)")
    }
    if !fileManager.fileExistsAtPath(roostfilePath) {
      printAndExit("Missing \(roostfilePath)")
    }

    let (versions) = parseMetadata(readFile(metadataPath))
    let (roostfileName, roostfileVersion) = parseRoostfile(roostfilePath)

    assert(roostfileName == name, "Roostfile.yaml's name doesn't equal directory name (\(name))")

    return Package(name: roostfileName,
                   version: roostfileVersion,
                   versions: versions)
  }

  private class func parseRoostfile(path: String) -> (String, SemVer) {
    var name: String!
    let roostfile: Yaml

    let contents = readFile(path)
    let result = Yaml.load(contents)

    if let error = result.error { printAndExit(error) }

    roostfile = result.value!

    if let hasName = roostfile["name"].string {
      name = hasName
    } else {
      printAndExit("Failed finding name in package's Roostfile")
    }

    let (error, version) = SemVer.parse(roostfile["version"].string!)

    if let error = error {
      printAndExit(error)
    }

    return (name, version!)
  }

  private class func parseMetadata(contents: String) -> [Version] {
    let result = Yaml.load(contents)

    if let error = result.error { printAndExit(error) }

    let metadata = result.value!
    let versions: [Yaml] = metadata["versions"].array!

    return versions.map { (v: Yaml) -> Version in
      let description = v["description"].string!

      let (error, version) = SemVer.parse(v["version"].string!)

      if let error = error { printAndExit(error) }

      return Version(version: version!, description: description)
    }
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
