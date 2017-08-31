//
//  CollectionViewController.swift
//  Virtual Tourist
//
//  Created by Anthony Guella on 8/23/17.
//  Copyright © 2017 Anthony Guella. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class ImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    
    
    //Variables
    var pin: Pin? = nil
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var savedImages: [Photo] = []
    var selectedToDelete: [Int] = [] {
        didSet {
            if selectedToDelete.count > 0 {
                newCollectionButton.setTitle("Remove Selected Pictures", for: .normal)
            } else {
                newCollectionButton.setTitle("New Collection", for: .normal)
            }
        }
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Photo> = {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin!)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseController.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
       
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.addAnnotation(pin!)
        mapView.setRegion(MKCoordinateRegion(center: pin!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05 )), animated: true)
        mapView.isUserInteractionEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        
        fetchedResultsController.delegate = self
        
        setupCollectionFlowLayout()
        
        let savedPhotos = preloadPhotos()
        if savedPhotos != nil && savedPhotos?.count != 0 {
            savedImages = savedPhotos!
            showSavedResult()
            
        } else {
            
            showNewResult()
        } 
    }
    
    
    //MARK: Methods
    /*
     * Sets up the collectionview layout
    */
    func setupCollectionFlowLayout() {
        let items: CGFloat = view.frame.size.width > view.frame.size.height ? 5.0 : 3.0
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - ((items + 1) * space)) / items
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 8.0 - items
        layout.minimumInteritemSpacing = space
        layout.itemSize = CGSize(width: dimension, height: dimension)
        
        collectionView.collectionViewLayout = layout
    }
    
    /*
     * Fetches saved photos
     */
    func preloadPhotos() -> [Photo]? {
        do {
            var photoArray:[Photo] = []
            try fetchedResultsController.performFetch()
            let photoCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            
            for index in 0..<photoCount {
                
                photoArray.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)))
            }
            
            return photoArray
            
        } catch {
            
            return nil
        }
    }
    
    /*
     * Show's fetched photos
     */
    func showSavedResult() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    /*
     * Gets new photos
     */
    func showNewResult() {
        newCollectionButton.isEnabled = false
        deleteExistingCoreDataPhotos()
        savedImages.removeAll()
        collectionView.reloadData()
        
        self.pin!.getNewPhotos(context: DatabaseController.getContext())
        
        DispatchQueue.main.async {
            self.savedImages = self.preloadPhotos()!
            self.showSavedResult()
            self.newCollectionButton.isEnabled = true
        }
      }
    
    /*
     * Deletes exising images from core data
     */
    func deleteExistingCoreDataPhotos() {
        for image in savedImages {
            DatabaseController.getContext().delete(image)
        }
    }
    
    /*
     * Gets rows of IndexPath objects
     */
    func getIndexPathRows(_ indexPathArray: [IndexPath]) -> [Int] {
        var selected:[Int] = []
        
        for indexPath in indexPathArray {
            
            selected.append(indexPath.row)
        }
        return selected
    }
    
    /*
     * Deletes selected Pictures
     */
    func removeSelectedPictures() {
        for index in 0..<savedImages.count {
            if selectedToDelete.contains(index) {
                DatabaseController.getContext().delete(savedImages[index])
            }
        }
        do {
            try DatabaseController.getContext().save()
        }
        catch {
            print("Save failed")
        }
        selectedToDelete.removeAll()
    }
    
    /*
     * Unselects all pictures
     */
    func unselectAll() {
        for index in collectionView.indexPathsForSelectedItems! {
            collectionView.deselectItem(at: index, animated: false)
            collectionView.cellForItem(at: index)?.alpha = 1.0
        }
    }
    
    
    //MARK: IBActions
    /*
     *  Gets new collection or deletes selected images
     */
    @IBAction func newCollection(_ sender: Any) {
        if selectedToDelete.count > 0 {
            
            removeSelectedPictures()
            unselectAll()
            savedImages = preloadPhotos()!
            showSavedResult()
        } else {
            showNewResult()
        }
    }
    
    // MARK: Collection View Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = fetchedResultsController.object(at: indexPath)
        cell.photo = photo
        cell.contentView.alpha = 1.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedToDelete = getIndexPathRows(collectionView.indexPathsForSelectedItems!)
        let cell = collectionView.cellForItem(at: indexPath)
        
        DispatchQueue.main.async {
            cell?.contentView.alpha = 0.5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedToDelete = getIndexPathRows(collectionView.indexPathsForSelectedItems!)
        let cell = collectionView.cellForItem(at: indexPath)
        
        DispatchQueue.main.async {
            cell?.contentView.alpha = 1.0
        }
    }
}

extension ImagesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = []
        deletedIndexPaths = []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            insertedIndexPaths.append(newIndexPath! as NSIndexPath)
        case .delete:
            deletedIndexPaths.append(indexPath! as NSIndexPath)
        default: ()
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({ 
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItems(at: [indexPath as IndexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItems(at: [indexPath as IndexPath])
            }
        }, completion: nil)
    }
}
