pragma solidity 0.8.0;
pragma experimental ABIEncoderV2;


import "../../libs/charged-particles-universe/contracts/tokens/Proton.sol"
import "./ERC3664/ERC3664.sol";
import "./Synthetic/ISynthetic.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract isoProton is 
    Proton,
	ERC3664, 
	ERC721Enumerable,
	Ownable
{
  
	uint256 public constant MASS_NFT = 1;
	uint256 public constant VERTICES_NFT = 2;
	uint256 public constant EDGES_NFT = 3;

	struct SynthesizedToken {
        address owner;
        uint256 id;
    }
	
	//string[] public node;

    // mainToken => SynthesizedToken
    mapping(uint256 => SynthesizedToken[]) public synthesizedTokens;

	constructor() ERC721('Mass', 'NODE') Ownable(){
		_mint(MASS_NFT, 'MASS', 'mass', '');
		_mint(VERTICES_NFT, 'VERTICES', 'vertices', '');
		_mint(EDGES_NFT, 'EDGES', 'edges', '');
	}

	function claim(uint256 tokenId) public {
        //require(tokenId > 0 && tokenId < 7981, "Token ID invalid");
        //        uint256 amount = msg.value;
        //        require(amount >= 15 * 10 ** 16, "Payed too low value");
        //        Address.sendValue(treasury, 15 * 10 ** 16);
		//buildings.push(kind);
		//uint256 tokenId = buildings.length - 1;
        _safeMint(_msgSender(), tokenId);
        _afterTokenMint(tokenId);
        //        emit Claimed(treasury, amount, tokenId);
    }

	function _afterTokenMint(uint256 tokenId) internal virtual {
        //attach(tokenId, UNNAMED_PROJECT_NFT, 1, bytes("unnamed"), true);
        //uint256 id = _totalSupply + (tokenId - 1) * 8 + 1;
		
		attach(tokenId, MASS_NFT, 1, bytes("mass"), true);
		// Produce attr id
		uint256 id = 101;

        // MASS
        mintSubToken(MASS_NFT, tokenId, id);
        // VERTICES
        mintSubToken(VERTICES_NFT, tokenId, id + 1);
        // EDGES
        mintSubToken(EDGES_NFT, tokenId, id + 2);
    }

	function getSubTokens(uint256 tokenId)
        public
        view
        returns (uint256[] memory)
    {
        SynthesizedToken[] storage tokens = synthesizedTokens[tokenId];
        uint256[] memory subs = new uint256[](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            subs[i] = tokens[i].id;
        }
        return subs;
    }

	function mintSubToken(
		uint256 attr,
        uint256 tokenId,
        uint256 subId
    ) internal virtual {
        _mint(address(this), subId);
        attach(subId, attr, 1, bytes(""), true);
        synthesizedTokens[tokenId].push(SynthesizedToken(_msgSender(), subId));
    }


	function supportsInterface(bytes4 interfaceId)
		public
		view
		virtual
		override(ERC3664, ERC721Enumerable)
		returns (bool)
	{
		return
			interfaceId == type(ISynthetic).interfaceId ||
			super.supportsInterface(interfaceId);
	}
  
}