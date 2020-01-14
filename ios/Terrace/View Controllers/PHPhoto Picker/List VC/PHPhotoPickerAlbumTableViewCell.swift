//
//  PHPhotoPickerAlbumTableViewCell.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit

class PHPhotoPickerAlbumTableViewCell: UITableViewCell {

  @IBOutlet weak var albumNameLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configure(albumItem: AlbumItem) {
    self.albumNameLabel.text = albumItem.albumResult.localizedTitle ?? albumItem.name
    self.subtitleLabel.text = "\(albumItem.count)"
    let sizeScaled = self.thumbnailImageView.frame.size.width * UIScreen.main.scale
    self.thumbnailImageView.image = PhotosHelper.lastImageFromCollection(albumItem.albumResult,
                                                                         size: CGSize(width: sizeScaled, height: sizeScaled) )
  }

}
