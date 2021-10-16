pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Queue {

    struct task {
        string label;
        uint32 timestamp;
        bool flagComplite;
    }

    mapping(int8 => task) taskList;

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

    function addTask(string taskLabel) public checkOwnerAndAccept{
        task newTask = task(taskLabel, now, false);
        int8 index = 0;
        while (taskList[index].timestamp != 0){
            index++;
        }
        taskList[index] = newTask;
    }

    function countOpenTask() public view returns(int8){
        int8 index = 0;
        int8 count = 0;
        while (taskList[index].timestamp != 0){
            index++;
            if (!taskList[index].flagComplite){
                count++;
            }
        }
        return count;
    }

    function printTaskList() public view returns(mapping(int8 => task)){
        return taskList;
    }

    function printTaskByKey(int8 key) public view returns(task){
        return taskList[key];
    }

    function deleteTask(int8 key) public checkOwnerAndAccept {
        delete taskList[key];
    }

    function compliteTask(int8 key) public checkOwnerAndAccept {
        taskList[key].flagComplite = true;
    }
}
