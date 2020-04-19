pragma solidity ^0.5.15;

import "ds-test/test.sol";
import {DSToken} from "ds-token/token.sol";

import {Vat}     from "../vat.sol";
import {Flipper} from "../flip.sol";
import {Spotter} from "../spot.sol";

contract Hevm {
    function warp(uint256) public;
}

contract Guy {
    Flipper flip;
    constructor(Flipper flip_) public {
        flip = flip_;
    }
    function hope(address usr) public {
        Vat(address(flip.vat())).hope(usr);
    }
    function tend(uint id, uint lot, uint bid) public {
        flip.tend(id, lot, bid);
    }
    function dent(uint id, uint lot, uint bid) public {
        flip.dent(id, lot, bid);
    }
    function deal(uint id) public {
        flip.deal(id);
    }
    function try_tend(uint id, uint lot, uint bid)
        public returns (bool ok)
    {
        string memory sig = "tend(uint256,uint256,uint256)";
        (ok,) = address(flip).call(abi.encodeWithSignature(sig, id, lot, bid));
    }
    function try_dent(uint id, uint lot, uint bid)
        public returns (bool ok)
    {
        string memory sig = "dent(uint256,uint256,uint256)";
        (ok,) = address(flip).call(abi.encodeWithSignature(sig, id, lot, bid));
    }
    function try_deal(uint id)
        public returns (bool ok)
    {
        string memory sig = "deal(uint256)";
        (ok,) = address(flip).call(abi.encodeWithSignature(sig, id));
    }
    function try_tick(uint id)
        public returns (bool ok)
    {
        string memory sig = "tick(uint256)";
        (ok,) = address(flip).call(abi.encodeWithSignature(sig, id));
    }
    function try_yank(uint id)
        public returns (bool ok)
    {
        string memory sig = "yank(uint256)";
        (ok,) = address(flip).call(abi.encodeWithSignature(sig, id));
    }
}


contract Gal {}

contract Vat_ is Vat {
    function mint(address usr, uint wad) public {
        good[usr] += wad;
    }
    function coin_balance(address usr) public view returns (uint) {
        return good[usr];
    }
    bytes32 ilk;
    function set_ilk(bytes32 ilk_) public {
        ilk = ilk_;
    }
    function gem_balance(address usr) public view returns (uint) {
        return gem[ilk][usr];
    }
}

contract Feed {
    bytes32 public val;
    bool public has;
    constructor(bytes32 initVal, bool initHas) public {
        val = initVal;
        has = initHas;
    }
    function set_val(bytes32 newVal) external {
        val = newVal;
    }
    function set_has(bool newHas) external {
        has = newHas;
    }
    function peek() external returns (bytes32, bool) {
        return (val, has);
    }
}

contract FlipTest is DSTest {
    Hevm hevm;

    Vat_    vat;
    Flipper flip;
    Spotter spot;
    Feed    feed;

    address ali;
    address bob;
    address gal;
    address usr = address(0xacab);

    function setUp() public {
        hevm = Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
        hevm.warp(604411200);

        vat = new Vat_();

        vat.init("gems");
        vat.set_ilk("gems");

        flip = new Flipper(address(vat), "gems");

        spot = new Spotter(address(vat));
        flip.file("spot", address(spot));

        feed = new Feed(bytes32(uint256(0)), true);
        flip.file("feed", address(feed));

        ali = address(new Guy(flip));
        bob = address(new Guy(flip));
        gal = address(new Gal());

        Guy(ali).hope(address(flip));
        Guy(bob).hope(address(flip));
        vat.hope(address(flip));

        vat.slip("gems", address(this), 1000 ether);
        vat.mint(ali, 200 ether);
        vat.mint(bob, 200 ether);
    }
    function test_kick() public {
        flip.kick({ lot: 100 ether
                  , tab: 50 ether
                  , usr: usr
                  , gal: gal
                  , bid: 0
                  });
    }
    function testFail_tend_empty() public {
        // can't tend on non-existent
        flip.tend(42, 0, 0);
    }
    function test_tend_dent_same_bidder() public {
       uint id = flip.kick({ lot: 100 ether
                            , tab: 200 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });

        assertEq(vat.coin_balance(ali), 200 ether);
        Guy(ali).tend(id, 100 ether, 190 ether);
        assertEq(vat.coin_balance(ali), 10 ether);
        Guy(ali).tend(id, 100 ether, 200 ether);
        assertEq(vat.coin_balance(ali), 0);
        Guy(ali).dent(id, 80 ether, 200 ether);
    }
    function test_tend() public {
        uint id = flip.kick({ lot: 100 ether
                            , tab: 50 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });

        Guy(ali).tend(id, 100 ether, 1 ether);
        // bid taken from bidder
        assertEq(vat.coin_balance(ali),   199 ether);
        // gal receives payment
        assertEq(vat.coin_balance(gal),     1 ether);

        Guy(bob).tend(id, 100 ether, 2 ether);
        // bid taken from bidder
        assertEq(vat.coin_balance(bob), 198 ether);
        // prev bidder refunded
        assertEq(vat.coin_balance(ali), 200 ether);
        // gal receives excess
        assertEq(vat.coin_balance(gal),   2 ether);

        hevm.warp(now + 5 hours);
        Guy(bob).deal(id);
        // bob gets the winnings
        assertEq(vat.gem_balance(bob), 100 ether);
    }
    function test_tend_later() public {
        uint id = flip.kick({ lot: 100 ether
                            , tab: 50 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });
        hevm.warp(now + 5 hours);

        Guy(ali).tend(id, 100 ether, 1 ether);
        // bid taken from bidder
        assertEq(vat.coin_balance(ali), 199 ether);
        // gal receives payment
        assertEq(vat.coin_balance(gal),   1 ether);
    }
    function test_tend_nonzero_cut() public {
        vat.mint(ali, 200 * 10**45 - 200 ether);
        flip.file("cut", 5 * 10**26); // one half
        feed.set_val(bytes32(uint256(200 ether)));
        uint id = flip.kick({ lot: 1 ether
                            , tab: 150 * 10**45
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });
        Guy(ali).tend(id, 1 ether, 100 * 10**45);
    }
    function testFail_tend_nonzero_cut() public {
        vat.mint(ali, 200 * 10**45 - 200 ether);
        flip.file("cut", 5 * 10**26); // one half
        feed.set_val(bytes32(uint256(200 ether)));
        uint id = flip.kick({ lot: 1 ether
                            , tab: 150 * 10**45
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });
        Guy(ali).tend(id, 1 ether, 100 * 10**45 - 1);
    }
    function test_tend_nonzero_cut_nonzero_par() public {
        vat.mint(ali, 200 * 10**45 - 200 ether);
        flip.file("cut", 5 * 10**26); // one half
        spot.file("par", 2 * 10**27); // 2 REF per MAI
        feed.set_val(bytes32(uint256(200 ether)));
        uint id = flip.kick({ lot: 1 ether
                            , tab: 75 * 10**45
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });
        Guy(ali).tend(id, 1 ether, 50 * 10**45);
    }
    function testFail_tend_nonzero_cut_nonzero_par() public {
        vat.mint(ali, 200 * 10**45 - 200 ether);
        flip.file("cut", 5 * 10**26); // one half
        spot.file("par", 2 * 10**27); // 2 REF per MAI
        feed.set_val(bytes32(uint256(200 ether)));
        uint id = flip.kick({ lot: 1 ether
                            , tab: 75 * 10**45
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });
        Guy(ali).tend(id, 1 ether, 50 * 10**45 - 1);
    }
    function test_dent() public {
        uint id = flip.kick({ lot: 100 ether
                            , tab: 50 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });
        Guy(ali).tend(id, 100 ether,  1 ether);
        Guy(bob).tend(id, 100 ether, 50 ether);

        Guy(ali).dent(id,  95 ether, 50 ether);
        // plop the gems
        assertEq(vat.gem_balance(address(0xacab)), 5 ether);
        assertEq(vat.coin_balance(ali),  150 ether);
        assertEq(vat.coin_balance(bob),  200 ether);
    }
    function test_beg() public {
        uint id = flip.kick({ lot: 100 ether
                            , tab: 50 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });
        assertTrue( Guy(ali).try_tend(id, 100 ether, 1.00 ether));
        assertTrue(!Guy(bob).try_tend(id, 100 ether, 1.01 ether));
        // high bidder is subject to beg
        assertTrue(!Guy(ali).try_tend(id, 100 ether, 1.01 ether));
        assertTrue( Guy(bob).try_tend(id, 100 ether, 1.07 ether));

        // can bid by less than beg at flip
        assertTrue( Guy(ali).try_tend(id, 100 ether, 49 ether));
        assertTrue( Guy(bob).try_tend(id, 100 ether, 50 ether));

        assertTrue(!Guy(ali).try_dent(id, 100 ether, 50 ether));
        assertTrue(!Guy(ali).try_dent(id,  99 ether, 50 ether));
        assertTrue( Guy(ali).try_dent(id,  95 ether, 50 ether));
    }
    function test_deal() public {
        uint id = flip.kick({ lot: 100 ether
                            , tab: 50 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });

        // only after ttl
        Guy(ali).tend(id, 100 ether, 1 ether);
        assertTrue(!Guy(bob).try_deal(id));
        hevm.warp(now + 4.1 hours);
        assertTrue( Guy(bob).try_deal(id));

        uint ie = flip.kick({ lot: 100 ether
                            , tab: 50 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });

        // or after end
        hevm.warp(now + 44 hours);
        Guy(ali).tend(ie, 100 ether, 1 ether);
        assertTrue(!Guy(bob).try_deal(ie));
        hevm.warp(now + 1 days);
        assertTrue( Guy(bob).try_deal(ie));
    }
    function test_tick() public {
        // start an auction
        uint id = flip.kick({ lot: 100 ether
                            , tab: 50 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });
        // check no tick
        assertTrue(!Guy(ali).try_tick(id));
        // run past the end
        hevm.warp(now + 2 weeks);
        // check not biddable
        assertTrue(!Guy(ali).try_tend(id, 100 ether, 1 ether));
        assertTrue( Guy(ali).try_tick(id));
        // check biddable
        assertTrue( Guy(ali).try_tend(id, 100 ether, 1 ether));
    }
    function test_no_deal_after_end() public {
        // if there are no bids and the auction ends, then it should not
        // be refundable to the creator. Rather, it ticks indefinitely.
        uint id = flip.kick({ lot: 100 ether
                            , tab: 50 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });
        assertTrue(!Guy(ali).try_deal(id));
        hevm.warp(now + 2 weeks);
        assertTrue(!Guy(ali).try_deal(id));
        assertTrue( Guy(ali).try_tick(id));
        assertTrue(!Guy(ali).try_deal(id));
    }
    function test_yank_tend() public {
        uint id = flip.kick({ lot: 100 ether
                            , tab: 50 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });

        Guy(ali).tend(id, 100 ether, 1 ether);
        // bid taken from bidder
        assertEq(vat.coin_balance(ali),   199 ether);
        assertEq(vat.coin_balance(gal),     1 ether);

        vat.mint(address(this), 1 ether);
        flip.yank(id);
        // bid is refunded to bidder from caller
        assertEq(vat.coin_balance(ali),            200 ether);
        assertEq(vat.coin_balance(address(this)),    0 ether);
        // gems go to caller
        assertEq(vat.gem_balance(address(this)), 1000 ether);
    }
    function test_yank_dent() public {
        uint id = flip.kick({ lot: 100 ether
                            , tab: 50 ether
                            , usr: usr
                            , gal: gal
                            , bid: 0
                            });
        Guy(ali).tend(id, 100 ether,  1 ether);
        Guy(bob).tend(id, 100 ether, 50 ether);
        Guy(ali).dent(id,  95 ether, 50 ether);

        // cannot yank in the dent phase
        assertTrue(!Guy(ali).try_yank(id));
    }
}
