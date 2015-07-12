import Foundation

class Index {

  
  private let formatter: NSDateFormatter = NSDateFormatter()

  init() {
    formatter.dateFormat = "yyyy-mm-dd'T'HH-mm-ss'Z'"

  }


  func packPackages(packages: [Package]) {
    let path = getOutputName()

    if !fileManager.createFileAtPath(path, contents: nil, attributes: nil) {
      printAndExit("Failed to create index file '\(path)'")
    }

    let file = NSFileHandle(forWritingAtPath: getOutputName())!

    let header = "Roost Index Version 1\n"
    file.writeData(header.dataUsingEncoding(NSUTF8StringEncoding)!)
  }

  func getOutputName() -> String {
    let date = formatter.stringFromDate(NSDate())

    return "Index-\(date).bin"
  }

}
