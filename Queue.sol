pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Queue {
    
    string[] queue;

    constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	// Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    function pushToQueue(string name) public checkOwnerAndAccept {
        queue.push(name);
    }

    function popFromQueue() public checkOwnerAndAccept {
        for (uint256 index = 1; index < queue.length; index++) {
            queue[index - 1] = queue[index];
        }
        queue.pop();
    }

    function printQueue() public view returns(string[]){
        return queue;
    }
}