// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LessonPlanMarketplace {
    address public owner;
    uint256 public planCount = 0;

    struct LessonPlan {
        uint256 id;
        address payable creator;
        string title;
        string description;
        string contentHash; // IPFS or other hash for content storage
        uint256 price;
        bool purchased;
    }

    mapping(uint256 => LessonPlan) public lessonPlans;

    event LessonPlanCreated(
        uint256 id,
        address creator,
        string title,
        uint256 price
    );

    event LessonPlanPurchased(
        uint256 id,
        address buyer
    );

    constructor() {
        owner = msg.sender;
    }

    function createLessonPlan(
        string memory _title,
        string memory _description,
        string memory _contentHash,
        uint256 _price
    ) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_contentHash).length > 0, "Content hash cannot be empty");
        require(_price > 0, "Price must be greater than zero");

        planCount++;
        lessonPlans[planCount] = LessonPlan(
            planCount,
            payable(msg.sender),
            _title,
            _description,
            _contentHash,
            _price,
            false
        );

        emit LessonPlanCreated(planCount, msg.sender, _title, _price);
    }

    function purchaseLessonPlan(uint256 _id) public payable {
        LessonPlan storage plan = lessonPlans[_id];
        require(plan.id > 0, "Lesson plan does not exist");
        require(!plan.purchased, "Lesson plan already purchased");
        require(msg.value >= plan.price, "Insufficient payment");
        
        plan.creator.transfer(plan.price);
        plan.purchased = true;

        emit LessonPlanPurchased(_id, msg.sender);
    }

    function getLessonPlan(uint256 _id)
        public
        view
        returns (
            uint256,
            address,
            string memory,
            string memory,
            uint256,
            bool
        )
    {
        LessonPlan memory plan = lessonPlans[_id];
        return (
            plan.id,
            plan.creator,
            plan.title,
            plan.description,
            plan.price,
            plan.purchased
        );
    }
}
