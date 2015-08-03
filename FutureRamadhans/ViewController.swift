
import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: variables for visualization
    // change city and years
    let city = "London"
    let years = 25
    
    let cellIdentifier = "TheCell"
    let headerIdentifier = "HeaderCell"
    
    var summaries: [RamadhanSummary]
    var durationRange = (0.0, 24.0)
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 10
        
        summaries = []
        
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        configureDefaultCells()
        configureTitleHeaderCell()
        configureRamadhanSummaries()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }
    
}

// MARK: Actions

extension ViewController {

    func configureRamadhanSummaries() {
        RamadhanSummary.summariesForCity(city, initialYear: 1437, durationInYears: years) { summaries in

            self.summaries = summaries
            self.durationRange = (
                summaries.map { $0.duration }.reduce(24.0) { min($0, $1) },
                19.0
            )

            self.collectionView?.reloadData()
        }
    }

    func saveInfographicToImage() {
        guard let collectionView = collectionView else {
            return
        }
        
        let snapshot = collectionView.rmdn_takeSnapshot()
        let imagePath = snapshot.rmdn_saveImageWithName(city)

        print("open '\(imagePath)'")
    }
}

// MARK: Cells

extension ViewController {
    
    func configureDefaultCells() {
        collectionView?.registerClass(SummaryCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return summaries.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! SummaryCell
        cell.summary = summaries[indexPath.item]
        cell.durationRange = durationRange
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.bounds) - 40.0 , height: 40.0)
    }
}

// MARK: Header

extension ViewController {
    
    func configureTitleHeaderCell() {
        collectionView?.registerClass(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.bounds), height: 60.0)
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerCell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! HeaderCell
            headerCell.label.text = "\(city)'s Ramadhan in the next \(years) years"
            headerCell.tapHandler = self.saveInfographicToImage
            return headerCell
        }
        
        return UICollectionReusableView()
    }
}

