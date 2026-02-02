// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WorkflowPractice {
    enum TaskStatus { Todo, InProgress, Review, Done }

    struct Task {
        string description;
        TaskStatus status;
    }

    mapping(uint => Task) public tasks;
    uint public taskCount;

    // TODO: 创建任务
    function createTask(string memory description) public returns (uint) {
        // 你的代码
        uint taskCountID = taskCount++;
        tasks[taskCountID] = Task({
            description: description,
            status: TaskStatus.InProgress
        });
        return taskCountID;
    }

    // TODO: 开始任务（从 Todo 转到 InProgress）
    function startTask(uint taskId) public {
        // 你的代码
        require(taskCount == )
    }

    // TODO: 提交审查（从 InProgress 转到 Review）
    function submitForReview(uint taskId) public {
        // 你的代码
    }

    // TODO: 完成任务（从 Review 转到 Done）
    function completeTask(uint taskId) public {
        // 你的代码
    }
}
