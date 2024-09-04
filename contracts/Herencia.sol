// SPDX-License-Identifier: MPL-2.0
pragma solidity >=0.7.0 <0.9.0;

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

contract B is A {
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

contract C is A {
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

contract E is A, B {
    function foo() public pure virtual override(A, B) returns (string memory) {
        return super.foo();
    }
}

contract f is B, C {
    function foo() public pure virtual override(B, C) returns (string memory) {
        return super.foo();
    }
}
