import Foundation

func main() {
  let names = Package.scanPackagesDirectory()
  let packages = names.map { Package.loadByName($0) }

  let index = Index()
  index.packPackages(packages)
}

main()
