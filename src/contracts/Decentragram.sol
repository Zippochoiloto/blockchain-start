pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  // Store Images
  mapping(uint => Image) public images;
  uint public imageCount = 0;
  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated (
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );
  
  event ImageTipped (
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );
  // Create Images

  function uploadImage(string memory _imgHash, string memory _description) public {
    require(bytes(_description).length > 0);
    require(bytes(_imgHash).length > 0);
    require(msg.sender != address(0x0));

    // Increase image id
    imageCount++;

    // Add time to contract
    images[imageCount] = Image(imageCount, _imgHash, _description, 0 ,msg.sender);   
    // Trigger an event
    emit ImageCreated(imageCount, _imgHash, _description, 0 , msg.sender);

  } 

  // Tip images
  function tipImageOwner (uint _id) public payable {
    require(_id > 0 && _id <= imageCount);
    
    // Fetch the image
    Image memory _image = images[_id];

    // Fetch the author
    address payable _author = _image.author;

    // Pay the author be sending them Ether
    address(_author).transfer(msg.value);

    _image.tipAmount = _image.tipAmount + msg.value;

    images[_id] = _image; 

    // Trigger an event
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }
}