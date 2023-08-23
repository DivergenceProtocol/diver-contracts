export const QuoterABI = {
  "abi": [
    {
      "inputs": [
        {
          "components": [
            {
              "internalType": "address",
              "name": "recipient",
              "type": "address"
            },
            {
              "internalType": "enum TradeAction",
              "name": "action",
              "type": "uint8"
            },
            {
              "internalType": "int256",
              "name": "amountSpecified",
              "type": "int256"
            },
            {
              "internalType": "uint160",
              "name": "sqrtPriceLimitX96",
              "type": "uint160"
            },
            {
              "internalType": "bytes",
              "name": "data",
              "type": "bytes"
            }
          ],
          "internalType": "struct TradeParamsBattle",
          "name": "params",
          "type": "tuple"
        },
        {
          "internalType": "address",
          "name": "battleAddr",
          "type": "address"
        }
      ],
      "name": "quoteExactInput",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "spend",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "get",
          "type": "uint256"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "enum TradeAction",
          "name": "action",
          "type": "uint8"
        },
        {
          "internalType": "int256",
          "name": "amountSpearDelta",
          "type": "int256"
        },
        {
          "internalType": "int256",
          "name": "amountShieldDelta",
          "type": "int256"
        },
        {
          "internalType": "int256",
          "name": "amountCollateralDelta",
          "type": "int256"
        },
        {
          "internalType": "bytes",
          "name": "data",
          "type": "bytes"
        }
      ],
      "name": "tradeCallback",
      "outputs": [],
      "stateMutability": "pure",
      "type": "function"
    }
  ],
  "bytecode": {
    "object": "0x608060405234801561001057600080fd5b506106e1806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80635d2652af1461003b57806364c2c15814610050575b600080fd5b61004e610049366004610281565b61007c565b005b61006361005e3660046103d2565b6100fe565b6040805192835260208301919091520160405180910390f35b60008080886003811115610092576100926104e6565b036100a15750839050856100ed565b60028860038111156100b5576100b56104e6565b036100c45750839050846100ed565b60018860038111156100d8576100d86104e6565b036100e75750859050836100ed565b50849050835b604051828152816020820152604081fd5b308252606082015160009081906001600160a01b031681036101a957600084602001516003811115610132576101326104e6565b14806101535750600384602001516003811115610151576101516104e6565b145b156101835761017060006c09f31acbab516e399f503dcc48610512565b6001600160a01b031660608501526101a9565b61019a6b19bac7780d08f3ad7f0af7b56000610539565b6001600160a01b031660608501525b6040516320787ae360e01b81526001600160a01b038416906320787ae3906101d5908790600401610559565b60c0604051808303816000875af1925050508015610210575060408051601f3d908101601f1916820190925261020d91810190610603565b60015b610264573d80801561023e576040519150601f19603f3d011682016040523d82523d6000602084013e610243565b606091505b50808060200190518101906102589190610687565b90935091506102669050565b505b9250929050565b80356004811061027c57600080fd5b919050565b60008060008060008060a0878903121561029a57600080fd5b6102a38761026d565b955060208701359450604087013593506060870135925060808701356001600160401b03808211156102d457600080fd5b818901915089601f8301126102e857600080fd5b8135818111156102f757600080fd5b8a602082850101111561030957600080fd5b6020830194508093505050509295509295509295565b634e487b7160e01b600052604160045260246000fd5b60405160a081016001600160401b03811182821017156103575761035761031f565b60405290565b60405160c081016001600160401b03811182821017156103575761035761031f565b604051601f8201601f191681016001600160401b03811182821017156103a7576103a761031f565b604052919050565b6001600160a01b03811681146103c457600080fd5b50565b803561027c816103af565b600080604083850312156103e557600080fd5b82356001600160401b03808211156103fc57600080fd5b9084019060a0828703121561041057600080fd5b610418610335565b8235610423816103af565b8152602061043284820161026d565b8183015260408401356040830152606084013561044e816103af565b606083015260808401358381111561046557600080fd5b80850194505087601f85011261047a57600080fd5b83358381111561048c5761048c61031f565b61049e601f8201601f1916830161037f565b935080845288828287010111156104b457600080fd5b80828601838601376000828286010152508260808301528195506104d98188016103c7565b9450505050509250929050565b634e487b7160e01b600052602160045260246000fd5b634e487b7160e01b600052601160045260246000fd5b6001600160a01b03828116828216039080821115610532576105326104fc565b5092915050565b6001600160a01b03818116838216019080821115610532576105326104fc565b6000602080835260018060a01b038085511682850152818501516004811061059157634e487b7160e01b600052602160045260246000fd5b806040860152506040850151606085015280606086015116608085015250608084015160a08085015280518060c086015260005b818110156105e15782810184015186820160e0015283016105c5565b50600060e0828701015260e0601f19601f830116860101935050505092915050565b600060c0828403121561061557600080fd5b61061d61035d565b82518152602083015160208201526040830151604082015260608301518060020b811461064957600080fd5b6060820152608083015161065c816103af565b608082015260a08301516001600160801b038116811461067b57600080fd5b60a08201529392505050565b6000806040838503121561069a57600080fd5b50508051602090910151909290915056fea2646970667358221220dd9259f98f32cf36bee3c95f12c8959bdf6f12107750fcf717b809b62653676664736f6c63430008100033",
    "sourceMap": "199:2128:96:-:0;;;;;;;;;;;;;;;;;;;",
    "linkReferences": {}
  },
  "deployedBytecode": {
    "object": "0x608060405234801561001057600080fd5b50600436106100365760003560e01c80635d2652af1461003b57806364c2c15814610050575b600080fd5b61004e610049366004610281565b61007c565b005b61006361005e3660046103d2565b6100fe565b6040805192835260208301919091520160405180910390f35b60008080886003811115610092576100926104e6565b036100a15750839050856100ed565b60028860038111156100b5576100b56104e6565b036100c45750839050846100ed565b60018860038111156100d8576100d86104e6565b036100e75750859050836100ed565b50849050835b604051828152816020820152604081fd5b308252606082015160009081906001600160a01b031681036101a957600084602001516003811115610132576101326104e6565b14806101535750600384602001516003811115610151576101516104e6565b145b156101835761017060006c09f31acbab516e399f503dcc48610512565b6001600160a01b031660608501526101a9565b61019a6b19bac7780d08f3ad7f0af7b56000610539565b6001600160a01b031660608501525b6040516320787ae360e01b81526001600160a01b038416906320787ae3906101d5908790600401610559565b60c0604051808303816000875af1925050508015610210575060408051601f3d908101601f1916820190925261020d91810190610603565b60015b610264573d80801561023e576040519150601f19603f3d011682016040523d82523d6000602084013e610243565b606091505b50808060200190518101906102589190610687565b90935091506102669050565b505b9250929050565b80356004811061027c57600080fd5b919050565b60008060008060008060a0878903121561029a57600080fd5b6102a38761026d565b955060208701359450604087013593506060870135925060808701356001600160401b03808211156102d457600080fd5b818901915089601f8301126102e857600080fd5b8135818111156102f757600080fd5b8a602082850101111561030957600080fd5b6020830194508093505050509295509295509295565b634e487b7160e01b600052604160045260246000fd5b60405160a081016001600160401b03811182821017156103575761035761031f565b60405290565b60405160c081016001600160401b03811182821017156103575761035761031f565b604051601f8201601f191681016001600160401b03811182821017156103a7576103a761031f565b604052919050565b6001600160a01b03811681146103c457600080fd5b50565b803561027c816103af565b600080604083850312156103e557600080fd5b82356001600160401b03808211156103fc57600080fd5b9084019060a0828703121561041057600080fd5b610418610335565b8235610423816103af565b8152602061043284820161026d565b8183015260408401356040830152606084013561044e816103af565b606083015260808401358381111561046557600080fd5b80850194505087601f85011261047a57600080fd5b83358381111561048c5761048c61031f565b61049e601f8201601f1916830161037f565b935080845288828287010111156104b457600080fd5b80828601838601376000828286010152508260808301528195506104d98188016103c7565b9450505050509250929050565b634e487b7160e01b600052602160045260246000fd5b634e487b7160e01b600052601160045260246000fd5b6001600160a01b03828116828216039080821115610532576105326104fc565b5092915050565b6001600160a01b03818116838216019080821115610532576105326104fc565b6000602080835260018060a01b038085511682850152818501516004811061059157634e487b7160e01b600052602160045260246000fd5b806040860152506040850151606085015280606086015116608085015250608084015160a08085015280518060c086015260005b818110156105e15782810184015186820160e0015283016105c5565b50600060e0828701015260e0601f19601f830116860101935050505092915050565b600060c0828403121561061557600080fd5b61061d61035d565b82518152602083015160208201526040830151604082015260608301518060020b811461064957600080fd5b6060820152608083015161065c816103af565b608082015260a08301516001600160801b038116811461067b57600080fd5b60a08201529392505050565b6000806040838503121561069a57600080fd5b50508051602090910151909290915056fea2646970667358221220dd9259f98f32cf36bee3c95f12c8959bdf6f12107750fcf717b809b62653676664736f6c63430008100033",
    "sourceMap": "199:2128:96:-:0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;239:964;;;;;;:::i;:::-;;:::i;:::-;;1607:718;;;;;;:::i;:::-;;:::i;:::-;;;;3961:25:115;;;4017:2;4002:18;;3995:34;;;;3934:18;1607:718:96;;;;;;;239:964;446:10;;;488:6;:31;;;;;;;;:::i;:::-;;484:550;;-1:-1:-1;548:21:96;;-1:-1:-1;598:16:96;484:550;;;646:22;636:6;:32;;;;;;;;:::i;:::-;;632:402;;-1:-1:-1;697:21:96;;-1:-1:-1;747:17:96;632:402;;;796:22;786:6;:32;;;;;;;;:::i;:::-;;782:252;;-1:-1:-1;847:16:96;;-1:-1:-1;892:21:96;782:252;;;-1:-1:-1;958:17:96;;-1:-1:-1;1001:21:96;782:252;1083:4;1077:11;1113:5;1108:3;1101:18;1155:3;1148:4;1143:3;1139:14;1132:27;1184:2;1179:3;1172:15;1607:718;1766:4;1739:32;;1785:24;;;;1701:13;;;;-1:-1:-1;;;;;1785:29:96;;;1781:358;;1851:21;1834:6;:13;;;:38;;;;;;;;:::i;:::-;;:82;;;-1:-1:-1;1893:23:96;1876:6;:13;;;:40;;;;;;;;:::i;:::-;;1834:82;1830:299;;;1994:27;2020:1;1092:30:63;1994:27:96;:::i;:::-;-1:-1:-1;;;;;1967:54:96;:24;;;:54;1830:299;;;2087:27;885:37:63;2113:1:96;2087:27;:::i;:::-;-1:-1:-1;;;;;2060:54:96;:24;;;:54;1830:299;2165:40;;-1:-1:-1;;;2165:40:96;;-1:-1:-1;;;;;2165:32:96;;;;;:40;;2198:6;;2165:40;;;:::i;:::-;;;;;;;;;;;;;;;;;;;;-1:-1:-1;2165:40:96;;;;;;;;-1:-1:-1;;2165:40:96;;;;;;;;;;;;:::i;:::-;;;2148:171;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;2287:6;2276:32;;;;;;;;;;;;:::i;:::-;2260:48;;-1:-1:-1;2260:48:96;-1:-1:-1;2148:171:96;;-1:-1:-1;2148:171:96;;;;1607:718;;;;;:::o;14:152:115:-;91:20;;140:1;130:12;;120:40;;156:1;153;146:12;120:40;14:152;;;:::o;171:894::-;291:6;299;307;315;323;331;384:3;372:9;363:7;359:23;355:33;352:53;;;401:1;398;391:12;352:53;424:38;452:9;424:38;:::i;:::-;414:48;-1:-1:-1;509:2:115;494:18;;481:32;;-1:-1:-1;560:2:115;545:18;;532:32;;-1:-1:-1;611:2:115;596:18;;583:32;;-1:-1:-1;666:3:115;651:19;;638:33;-1:-1:-1;;;;;720:14:115;;;717:34;;;747:1;744;737:12;717:34;785:6;774:9;770:22;760:32;;830:7;823:4;819:2;815:13;811:27;801:55;;852:1;849;842:12;801:55;892:2;879:16;918:2;910:6;907:14;904:34;;;934:1;931;924:12;904:34;979:7;974:2;965:6;961:2;957:15;953:24;950:37;947:57;;;1000:1;997;990:12;947:57;1031:2;1027;1023:11;1013:21;;1053:6;1043:16;;;;;171:894;;;;;;;;:::o;1070:127::-;1131:10;1126:3;1122:20;1119:1;1112:31;1162:4;1159:1;1152:15;1186:4;1183:1;1176:15;1202:253;1274:2;1268:9;1316:4;1304:17;;-1:-1:-1;;;;;1336:34:115;;1372:22;;;1333:62;1330:88;;;1398:18;;:::i;:::-;1434:2;1427:22;1202:253;:::o;1460:252::-;1532:2;1526:9;1574:3;1562:16;;-1:-1:-1;;;;;1593:34:115;;1629:22;;;1590:62;1587:88;;;1655:18;;:::i;1717:275::-;1788:2;1782:9;1853:2;1834:13;;-1:-1:-1;;1830:27:115;1818:40;;-1:-1:-1;;;;;1873:34:115;;1909:22;;;1870:62;1867:88;;;1935:18;;:::i;:::-;1971:2;1964:22;1717:275;;-1:-1:-1;1717:275:115:o;1997:131::-;-1:-1:-1;;;;;2072:31:115;;2062:42;;2052:70;;2118:1;2115;2108:12;2052:70;1997:131;:::o;2133:134::-;2201:20;;2230:31;2201:20;2230:31;:::i;2272:1510::-;2376:6;2384;2437:2;2425:9;2416:7;2412:23;2408:32;2405:52;;;2453:1;2450;2443:12;2405:52;2480:23;;-1:-1:-1;;;;;2552:14:115;;;2549:34;;;2579:1;2576;2569:12;2549:34;2602:22;;;;2658:4;2640:16;;;2636:27;2633:47;;;2676:1;2673;2666:12;2633:47;2702:22;;:::i;:::-;2761:2;2748:16;2773:33;2798:7;2773:33;:::i;:::-;2815:22;;2856:2;2890:40;2918:11;;;2890:40;:::i;:::-;2885:2;2878:5;2874:14;2867:64;2984:2;2980;2976:11;2963:25;2958:2;2951:5;2947:14;2940:49;3034:2;3030;3026:11;3013:25;3047:33;3072:7;3047:33;:::i;:::-;3107:2;3096:14;;3089:31;3166:3;3158:12;;3145:26;3183:16;;;3180:36;;;3212:1;3209;3202:12;3180:36;3243:8;3239:2;3235:17;3225:27;;;3290:7;3283:4;3279:2;3275:13;3271:27;3261:55;;3312:1;3309;3302:12;3261:55;3348:2;3335:16;3370:2;3366;3363:10;3360:36;;;3376:18;;:::i;:::-;3418:53;3461:2;3442:13;;-1:-1:-1;;3438:27:115;3434:36;;3418:53;:::i;:::-;3405:66;;3494:2;3487:5;3480:17;3534:7;3529:2;3524;3520;3516:11;3512:20;3509:33;3506:53;;;3555:1;3552;3545:12;3506:53;3610:2;3605;3601;3597:11;3592:2;3585:5;3581:14;3568:45;3654:1;3649:2;3644;3637:5;3633:14;3629:23;3622:34;;3689:5;3683:3;3676:5;3672:15;3665:30;3714:5;3704:15;;3738:38;3772:2;3761:9;3757:18;3738:38;:::i;:::-;3728:48;;;;;;2272:1510;;;;;:::o;4040:127::-;4101:10;4096:3;4092:20;4089:1;4082:31;4132:4;4129:1;4122:15;4156:4;4153:1;4146:15;4172:127;4233:10;4228:3;4224:20;4221:1;4214:31;4264:4;4261:1;4254:15;4288:4;4285:1;4278:15;4304:185;-1:-1:-1;;;;;4425:10:115;;;4413;;;4409:27;;4448:12;;;4445:38;;;4463:18;;:::i;:::-;4445:38;4304:185;;;;:::o;4494:182::-;-1:-1:-1;;;;;4601:10:115;;;4613;;;4597:27;;4636:11;;;4633:37;;;4650:18;;:::i;4681:1201::-;4845:4;4874:2;4903;4892:9;4885:21;4942:1;4938;4933:3;4929:11;4925:19;4999:2;4990:6;4984:13;4980:22;4975:2;4964:9;4960:18;4953:50;5050:2;5042:6;5038:15;5032:22;5090:1;5076:12;5073:19;5063:150;;5135:10;5130:3;5126:20;5123:1;5116:31;5170:4;5167:1;5160:15;5198:4;5195:1;5188:15;5063:150;5249:12;5244:2;5233:9;5229:18;5222:40;;5316:2;5308:6;5304:15;5298:22;5293:2;5282:9;5278:18;5271:50;5386:2;5380;5372:6;5368:15;5362:22;5358:31;5352:3;5341:9;5337:19;5330:60;;5439:3;5431:6;5427:16;5421:23;5482:4;5475;5464:9;5460:20;5453:34;5516:14;5510:21;5568:6;5562:3;5551:9;5547:19;5540:35;5593:1;5603:149;5617:6;5614:1;5611:13;5603:149;;;5713:22;;;5709:31;;5703:38;5678:17;;;5697:3;5674:27;5667:75;5632:10;;5603:149;;;5607:3;5802:1;5796:3;5787:6;5776:9;5772:22;5768:32;5761:43;5872:3;5865:2;5861:7;5856:2;5848:6;5844:15;5840:29;5829:9;5825:45;5821:55;5813:63;;;;;4681:1201;;;;:::o;5887:884::-;5999:6;6052:3;6040:9;6031:7;6027:23;6023:33;6020:53;;;6069:1;6066;6059:12;6020:53;6095:22;;:::i;:::-;6146:9;6140:16;6133:5;6126:31;6210:2;6199:9;6195:18;6189:25;6184:2;6177:5;6173:14;6166:49;6268:2;6257:9;6253:18;6247:25;6242:2;6235:5;6231:14;6224:49;6318:2;6307:9;6303:18;6297:25;6367:7;6364:1;6353:22;6344:7;6341:35;6331:63;;6390:1;6387;6380:12;6331:63;6421:2;6410:14;;6403:31;6479:3;6464:19;;6458:26;6493:33;6458:26;6493:33;:::i;:::-;6553:3;6542:15;;6535:32;6612:3;6597:19;;6591:26;-1:-1:-1;;;;;6648:33:115;;6636:46;;6626:74;;6696:1;6693;6686:12;6626:74;6727:3;6716:15;;6709:32;6720:5;5887:884;-1:-1:-1;;;5887:884:115:o;6776:245::-;6855:6;6863;6916:2;6904:9;6895:7;6891:23;6887:32;6884:52;;;6932:1;6929;6922:12;6884:52;-1:-1:-1;;6955:16:115;;7011:2;6996:18;;;6990:25;6955:16;;6990:25;;-1:-1:-1;6776:245:115:o",
    "linkReferences": {}
  },
  "methodIdentifiers": {
    "quoteExactInput((address,uint8,int256,uint160,bytes),address)": "64c2c158",
    "tradeCallback(uint8,int256,int256,int256,bytes)": "5d2652af"
  },
  "rawMetadata": "{\"compiler\":{\"version\":\"0.8.16+commit.07a7930e\"},\"language\":\"Solidity\",\"output\":{\"abi\":[{\"inputs\":[{\"components\":[{\"internalType\":\"address\",\"name\":\"recipient\",\"type\":\"address\"},{\"internalType\":\"enum TradeAction\",\"name\":\"action\",\"type\":\"uint8\"},{\"internalType\":\"int256\",\"name\":\"amountSpecified\",\"type\":\"int256\"},{\"internalType\":\"uint160\",\"name\":\"sqrtPriceLimitX96\",\"type\":\"uint160\"},{\"internalType\":\"bytes\",\"name\":\"data\",\"type\":\"bytes\"}],\"internalType\":\"struct TradeParamsBattle\",\"name\":\"params\",\"type\":\"tuple\"},{\"internalType\":\"address\",\"name\":\"battleAddr\",\"type\":\"address\"}],\"name\":\"quoteExactInput\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"spend\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"get\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"enum TradeAction\",\"name\":\"action\",\"type\":\"uint8\"},{\"internalType\":\"int256\",\"name\":\"amountSpearDelta\",\"type\":\"int256\"},{\"internalType\":\"int256\",\"name\":\"amountShieldDelta\",\"type\":\"int256\"},{\"internalType\":\"int256\",\"name\":\"amountCollateralDelta\",\"type\":\"int256\"},{\"internalType\":\"bytes\",\"name\":\"data\",\"type\":\"bytes\"}],\"name\":\"tradeCallback\",\"outputs\":[],\"stateMutability\":\"pure\",\"type\":\"function\"}],\"devdoc\":{\"kind\":\"dev\",\"methods\":{},\"version\":1},\"userdoc\":{\"kind\":\"user\",\"methods\":{},\"version\":1}},\"settings\":{\"compilationTarget\":{\"src/periphery/lens/Quoter.sol\":\"Quoter\"},\"evmVersion\":\"london\",\"libraries\":{},\"metadata\":{\"bytecodeHash\":\"ipfs\"},\"optimizer\":{\"enabled\":true,\"runs\":1},\"remappings\":[\":@oz/=lib/openzeppelin-contracts/contracts/\",\":core/=src/core/\",\":ds-test/=lib/forge-std/lib/ds-test/src/\",\":forge-std/=lib/forge-std/src/\",\":periphery/=src/periphery/\",\":self/=src/\",\":solmate/=lib/solmate/src/\",\":str-util/=lib/solidity-stringutils/\"]},\"sources\":{\"src/core/enum/PeriodType.sol\":{\"keccak256\":\"0xbd285518a34c38f005443f2690f0b8fe1d280219cd9c5413c2d594ac1d446dfc\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://d168ceb329ec7e43382d5c7d29392c4670c08c8a7739f3452d2b5967ae750b26\",\"dweb:/ipfs/QmTAUJJbXqwm3FP7GHD4Est3baeSNuaLvM8pcg6YKTGFzm\"]},\"src/core/enum/TradeAction.sol\":{\"keccak256\":\"0x812e396b86401c19d450e05c63161fa30dde67eca10ddf2cfd626bba2ef19c92\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://d69b613ac13ab94256eec7ea1010220c2cb5585c8d4de86935459d5be1b05b3a\",\"dweb:/ipfs/QmXVAEojNeeGmGYbHwYW1yjqG45vCTPvo1beub5oAEa596\"]},\"src/core/interfaces/battle/IBattleActions.sol\":{\"keccak256\":\"0xeab9e586aaf728998efdac6517462466d8a89850ac9ae0db719a96fe4b2f24b7\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://b7dad6e9d31414a85ea16df2149f3058dd7c770e530a23e283c809464cf30530\",\"dweb:/ipfs/QmPh3R643uqDRmDmTEXDyoRa9iRnfT1o6BVC6KA7B7Yjph\"]},\"src/core/interfaces/battle/IBattleImmutables.sol\":{\"keccak256\":\"0xac6bb78f53a62b5833589728c3da1ab27c557283931d6dbeac895d4e3778bb4b\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://c402bed39c4f085c5bd5d4d651f12a5df972d7b1ef068327436cfea397754b41\",\"dweb:/ipfs/QmaMFKHxsSALFSu7FNtSY1nwX5KGgAxfp2CPrfQjJbX7sS\"]},\"src/core/interfaces/battle/IBattleInit.sol\":{\"keccak256\":\"0xaefaead7c138573b0d75df85471198b987547316f37e2661b343279f8c95d287\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://e6a4d7f29fb9899c827cc746307a9eb5ab2d5821feec07db171b45cdd6ed737f\",\"dweb:/ipfs/QmZxm7znuMBeLpHgsBeBaQ5kQZzhiNBXvZ6rAJBtYt7QCD\"]},\"src/core/interfaces/callback/ITradeCallback.sol\":{\"keccak256\":\"0x4d2d3357cda19d4d2162c74c5c8feec5db5f07da07f3266727ec0553f08b64aa\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://8aa56a69948d511b2f52634a2028ee8edde54be5feee9c0f4b0795afd8733ac7\",\"dweb:/ipfs/QmfQ3ty49UcGP9z3H5NECjNdc6xAkWjC4zEGs7SPBTx7vP\"]},\"src/core/libs/TickMath.sol\":{\"keccak256\":\"0x9e82d3de136350af2ba0d25a6ebd5d976afc2644f87688ab9acb04a8edb89269\",\"license\":\"GPL-2.0-or-later\",\"urls\":[\"bzz-raw://38f1b9fb8fe2247a2dd5ee4d1b49aa2662221066dd8466be95ff2154f6157f61\",\"dweb:/ipfs/QmYdarqXJdfeCyLoB6GJBTuqjD4Wyah3dtPL9gaWZKtDa7\"]},\"src/core/params/BurnParamsBattle.sol\":{\"keccak256\":\"0x8563bfe5a2dea42bf35191cebefa620915e635c179f9811aa15e196bf6b01a97\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://f371c3ef5d7a15df4db6ed87b136cf2c70a577e29bc1fccf4a1644c63f7a9e7a\",\"dweb:/ipfs/QmPWimdheV6FZQb6Gw8DZWLzoEN59NgctJGgP1TKo4BTUB\"]},\"src/core/params/DeploymentParams.sol\":{\"keccak256\":\"0x0c8b94f1c37bccaaabcaa895a06f537c318419b04059ce536e1c93680b610ab4\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://2eb94c8a251a9d941855f6540b1f5cf63f9bdd3596971c500e9c2572f2747166\",\"dweb:/ipfs/QmSVKA3fwEWhtwqNbre18T8HNfHRrcfqy3DW5n7fwCZeBJ\"]},\"src/core/params/LpOwedDelta.sol\":{\"keccak256\":\"0x4b0c63d516e87b01dccf92c9edd16243d952fbb0483a6f98d39c3c50c878c09f\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://66092a32ab3fad66b9ff0a76b9e4d597e27e6e19254686b42c0538c384bc3c7f\",\"dweb:/ipfs/QmVBBNpr9fKSJHMeeP21Cev5BEcMTu9mVQGRVDRCSVFVcb\"]},\"src/core/params/MintParamsRound.sol\":{\"keccak256\":\"0x5865456edee17948dedcc83fcb1de37dd75936541545844570446ad637ef193d\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://dd2e2e63ac80c22b1d397fe4bcaf0dac9ca4d39d10dc970b8b0885bae0a2dd43\",\"dweb:/ipfs/QmQiPA55bN4rzPvn8hfihNwEtAZnNueiXJhvsHobqWexVg\"]},\"src/core/params/ModifyPositionParams.sol\":{\"keccak256\":\"0x91c5f877d98de56d03ae859b71731ea7b402b7b8221eabe5186054ed107e61c8\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://b23e0a18f3e99e3ce9d2cabe82ce7a6dadfb4bba492a6a9b9a188d370b7b25ba\",\"dweb:/ipfs/QmSLaZP4xV4ivr4jn7venvKs2Nu6Vs1GtW6643Eho7PizN\"]},\"src/core/params/TradeParamsBattle.sol\":{\"keccak256\":\"0xac8b05a5fcbe8a31ca275dac3cf4026bbfd9ad086d3b073fa4b65dded3678236\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://e84dfb7d5f5e4a5f5319ea3adbe49fd4a8d245788588fe119d2659be726da534\",\"dweb:/ipfs/QmU9ZkpQBkXAC5CLVAtEHLS8uaCXMu2GEgwLvn89PxywV8\"]},\"src/core/type/BattleKey.sol\":{\"keccak256\":\"0x870239c717ac03d5642c762d118e09f2a0febea2ec202f70d9603614b29b5090\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://c36359c7a7f069f33ffa72d8b8bc8ea681707dfe2cb03a88f7a8874836793edc\",\"dweb:/ipfs/QmZ7PwdViSVE9wvx7axnZ9cPEU9WujRLPS7TqhPRXuj33E\"]},\"src/core/type/PositionTypes.sol\":{\"keccak256\":\"0xf5f1a93a266e092e84829b7bdf634e3cc824d4d8046bc601cfce71764a8e5ada\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://b70bbc3aeaa7c4db97b53fda83f0827a233bb014fbdb88ff83e6501051fd6f39\",\"dweb:/ipfs/QmT8gj1m62fLZ9ZYaqkCe2M4y6caC7bGEkCt9TXM85dafN\"]},\"src/periphery/lens/Quoter.sol\":{\"keccak256\":\"0xbe6a4962c65e839fd8fc4b68616035ad4876fce82934b3afc1ab2b63d025905a\",\"license\":\"MIT\",\"urls\":[\"bzz-raw://80965504a4dfced1b2add41b209f64be010e1c4e639f412f11a0163c2c1fbf59\",\"dweb:/ipfs/QmRKS7X6xuKbBhLN2fQ761uNtFes1AjuKH9k9hds9z8LaP\"]}},\"version\":1}",
  "metadata": {
    "compiler": {
      "version": "0.8.16+commit.07a7930e"
    },
    "language": "Solidity",
    "output": {
      "abi": [
        {
          "inputs": [
            {
              "internalType": "struct TradeParamsBattle",
              "name": "params",
              "type": "tuple",
              "components": [
                {
                  "internalType": "address",
                  "name": "recipient",
                  "type": "address"
                },
                {
                  "internalType": "enum TradeAction",
                  "name": "action",
                  "type": "uint8"
                },
                {
                  "internalType": "int256",
                  "name": "amountSpecified",
                  "type": "int256"
                },
                {
                  "internalType": "uint160",
                  "name": "sqrtPriceLimitX96",
                  "type": "uint160"
                },
                {
                  "internalType": "bytes",
                  "name": "data",
                  "type": "bytes"
                }
              ]
            },
            {
              "internalType": "address",
              "name": "battleAddr",
              "type": "address"
            }
          ],
          "stateMutability": "nonpayable",
          "type": "function",
          "name": "quoteExactInput",
          "outputs": [
            {
              "internalType": "uint256",
              "name": "spend",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "get",
              "type": "uint256"
            }
          ]
        },
        {
          "inputs": [
            {
              "internalType": "enum TradeAction",
              "name": "action",
              "type": "uint8"
            },
            {
              "internalType": "int256",
              "name": "amountSpearDelta",
              "type": "int256"
            },
            {
              "internalType": "int256",
              "name": "amountShieldDelta",
              "type": "int256"
            },
            {
              "internalType": "int256",
              "name": "amountCollateralDelta",
              "type": "int256"
            },
            {
              "internalType": "bytes",
              "name": "data",
              "type": "bytes"
            }
          ],
          "stateMutability": "pure",
          "type": "function",
          "name": "tradeCallback"
        }
      ],
      "devdoc": {
        "kind": "dev",
        "methods": {},
        "version": 1
      },
      "userdoc": {
        "kind": "user",
        "methods": {},
        "version": 1
      }
    },
    "settings": {
      "remappings": [
        ":@oz/=lib/openzeppelin-contracts/contracts/",
        ":core/=src/core/",
        ":ds-test/=lib/forge-std/lib/ds-test/src/",
        ":forge-std/=lib/forge-std/src/",
        ":periphery/=src/periphery/",
        ":self/=src/",
        ":solmate/=lib/solmate/src/",
        ":str-util/=lib/solidity-stringutils/"
      ],
      "optimizer": {
        "enabled": true,
        "runs": 1
      },
      "metadata": {
        "bytecodeHash": "ipfs"
      },
      "compilationTarget": {
        "src/periphery/lens/Quoter.sol": "Quoter"
      },
      "libraries": {}
    },
    "sources": {
      "src/core/enum/PeriodType.sol": {
        "keccak256": "0xbd285518a34c38f005443f2690f0b8fe1d280219cd9c5413c2d594ac1d446dfc",
        "urls": [
          "bzz-raw://d168ceb329ec7e43382d5c7d29392c4670c08c8a7739f3452d2b5967ae750b26",
          "dweb:/ipfs/QmTAUJJbXqwm3FP7GHD4Est3baeSNuaLvM8pcg6YKTGFzm"
        ],
        "license": "MIT"
      },
      "src/core/enum/TradeAction.sol": {
        "keccak256": "0x812e396b86401c19d450e05c63161fa30dde67eca10ddf2cfd626bba2ef19c92",
        "urls": [
          "bzz-raw://d69b613ac13ab94256eec7ea1010220c2cb5585c8d4de86935459d5be1b05b3a",
          "dweb:/ipfs/QmXVAEojNeeGmGYbHwYW1yjqG45vCTPvo1beub5oAEa596"
        ],
        "license": "MIT"
      },
      "src/core/interfaces/battle/IBattleActions.sol": {
        "keccak256": "0xeab9e586aaf728998efdac6517462466d8a89850ac9ae0db719a96fe4b2f24b7",
        "urls": [
          "bzz-raw://b7dad6e9d31414a85ea16df2149f3058dd7c770e530a23e283c809464cf30530",
          "dweb:/ipfs/QmPh3R643uqDRmDmTEXDyoRa9iRnfT1o6BVC6KA7B7Yjph"
        ],
        "license": "MIT"
      },
      "src/core/interfaces/battle/IBattleImmutables.sol": {
        "keccak256": "0xac6bb78f53a62b5833589728c3da1ab27c557283931d6dbeac895d4e3778bb4b",
        "urls": [
          "bzz-raw://c402bed39c4f085c5bd5d4d651f12a5df972d7b1ef068327436cfea397754b41",
          "dweb:/ipfs/QmaMFKHxsSALFSu7FNtSY1nwX5KGgAxfp2CPrfQjJbX7sS"
        ],
        "license": "MIT"
      },
      "src/core/interfaces/battle/IBattleInit.sol": {
        "keccak256": "0xaefaead7c138573b0d75df85471198b987547316f37e2661b343279f8c95d287",
        "urls": [
          "bzz-raw://e6a4d7f29fb9899c827cc746307a9eb5ab2d5821feec07db171b45cdd6ed737f",
          "dweb:/ipfs/QmZxm7znuMBeLpHgsBeBaQ5kQZzhiNBXvZ6rAJBtYt7QCD"
        ],
        "license": "MIT"
      },
      "src/core/interfaces/callback/ITradeCallback.sol": {
        "keccak256": "0x4d2d3357cda19d4d2162c74c5c8feec5db5f07da07f3266727ec0553f08b64aa",
        "urls": [
          "bzz-raw://8aa56a69948d511b2f52634a2028ee8edde54be5feee9c0f4b0795afd8733ac7",
          "dweb:/ipfs/QmfQ3ty49UcGP9z3H5NECjNdc6xAkWjC4zEGs7SPBTx7vP"
        ],
        "license": "MIT"
      },
      "src/core/libs/TickMath.sol": {
        "keccak256": "0x9e82d3de136350af2ba0d25a6ebd5d976afc2644f87688ab9acb04a8edb89269",
        "urls": [
          "bzz-raw://38f1b9fb8fe2247a2dd5ee4d1b49aa2662221066dd8466be95ff2154f6157f61",
          "dweb:/ipfs/QmYdarqXJdfeCyLoB6GJBTuqjD4Wyah3dtPL9gaWZKtDa7"
        ],
        "license": "GPL-2.0-or-later"
      },
      "src/core/params/BurnParamsBattle.sol": {
        "keccak256": "0x8563bfe5a2dea42bf35191cebefa620915e635c179f9811aa15e196bf6b01a97",
        "urls": [
          "bzz-raw://f371c3ef5d7a15df4db6ed87b136cf2c70a577e29bc1fccf4a1644c63f7a9e7a",
          "dweb:/ipfs/QmPWimdheV6FZQb6Gw8DZWLzoEN59NgctJGgP1TKo4BTUB"
        ],
        "license": "MIT"
      },
      "src/core/params/DeploymentParams.sol": {
        "keccak256": "0x0c8b94f1c37bccaaabcaa895a06f537c318419b04059ce536e1c93680b610ab4",
        "urls": [
          "bzz-raw://2eb94c8a251a9d941855f6540b1f5cf63f9bdd3596971c500e9c2572f2747166",
          "dweb:/ipfs/QmSVKA3fwEWhtwqNbre18T8HNfHRrcfqy3DW5n7fwCZeBJ"
        ],
        "license": "MIT"
      },
      "src/core/params/LpOwedDelta.sol": {
        "keccak256": "0x4b0c63d516e87b01dccf92c9edd16243d952fbb0483a6f98d39c3c50c878c09f",
        "urls": [
          "bzz-raw://66092a32ab3fad66b9ff0a76b9e4d597e27e6e19254686b42c0538c384bc3c7f",
          "dweb:/ipfs/QmVBBNpr9fKSJHMeeP21Cev5BEcMTu9mVQGRVDRCSVFVcb"
        ],
        "license": "MIT"
      },
      "src/core/params/MintParamsRound.sol": {
        "keccak256": "0x5865456edee17948dedcc83fcb1de37dd75936541545844570446ad637ef193d",
        "urls": [
          "bzz-raw://dd2e2e63ac80c22b1d397fe4bcaf0dac9ca4d39d10dc970b8b0885bae0a2dd43",
          "dweb:/ipfs/QmQiPA55bN4rzPvn8hfihNwEtAZnNueiXJhvsHobqWexVg"
        ],
        "license": "MIT"
      },
      "src/core/params/ModifyPositionParams.sol": {
        "keccak256": "0x91c5f877d98de56d03ae859b71731ea7b402b7b8221eabe5186054ed107e61c8",
        "urls": [
          "bzz-raw://b23e0a18f3e99e3ce9d2cabe82ce7a6dadfb4bba492a6a9b9a188d370b7b25ba",
          "dweb:/ipfs/QmSLaZP4xV4ivr4jn7venvKs2Nu6Vs1GtW6643Eho7PizN"
        ],
        "license": "MIT"
      },
      "src/core/params/TradeParamsBattle.sol": {
        "keccak256": "0xac8b05a5fcbe8a31ca275dac3cf4026bbfd9ad086d3b073fa4b65dded3678236",
        "urls": [
          "bzz-raw://e84dfb7d5f5e4a5f5319ea3adbe49fd4a8d245788588fe119d2659be726da534",
          "dweb:/ipfs/QmU9ZkpQBkXAC5CLVAtEHLS8uaCXMu2GEgwLvn89PxywV8"
        ],
        "license": "MIT"
      },
      "src/core/type/BattleKey.sol": {
        "keccak256": "0x870239c717ac03d5642c762d118e09f2a0febea2ec202f70d9603614b29b5090",
        "urls": [
          "bzz-raw://c36359c7a7f069f33ffa72d8b8bc8ea681707dfe2cb03a88f7a8874836793edc",
          "dweb:/ipfs/QmZ7PwdViSVE9wvx7axnZ9cPEU9WujRLPS7TqhPRXuj33E"
        ],
        "license": "MIT"
      },
      "src/core/type/PositionTypes.sol": {
        "keccak256": "0xf5f1a93a266e092e84829b7bdf634e3cc824d4d8046bc601cfce71764a8e5ada",
        "urls": [
          "bzz-raw://b70bbc3aeaa7c4db97b53fda83f0827a233bb014fbdb88ff83e6501051fd6f39",
          "dweb:/ipfs/QmT8gj1m62fLZ9ZYaqkCe2M4y6caC7bGEkCt9TXM85dafN"
        ],
        "license": "MIT"
      },
      "src/periphery/lens/Quoter.sol": {
        "keccak256": "0xbe6a4962c65e839fd8fc4b68616035ad4876fce82934b3afc1ab2b63d025905a",
        "urls": [
          "bzz-raw://80965504a4dfced1b2add41b209f64be010e1c4e639f412f11a0163c2c1fbf59",
          "dweb:/ipfs/QmRKS7X6xuKbBhLN2fQ761uNtFes1AjuKH9k9hds9z8LaP"
        ],
        "license": "MIT"
      }
    },
    "version": 1
  },
  "ast": {
    "absolutePath": "src/periphery/lens/Quoter.sol",
    "id": 41867,
    "exportedSymbols": {
      "BattleKey": [
        39172
      ],
      "BurnParamsBattle": [
        38006
      ],
      "DeploymentParams": [
        38074
      ],
      "GrowthInsideLast": [
        39198
      ],
      "IBattleActions": [
        33354
      ],
      "IBattleImmutables": [
        33475
      ],
      "IBattleInit": [
        33496
      ],
      "ITradeCallback": [
        33595
      ],
      "LpOwedDelta": [
        38102
      ],
      "MintParamsRound": [
        38121
      ],
      "ModifyPositionParams": [
        38138
      ],
      "PeriodType": [
        32885
      ],
      "Quoter": [
        41866
      ],
      "TickMath": [
        37446
      ],
      "TradeAction": [
        32892
      ],
      "TradeParamsBattle": [
        38153
      ],
      "TradeReturnValuesBattle": [
        38166
      ]
    },
    "nodeType": "SourceUnit",
    "src": "33:2295:96",
    "nodes": [
      {
        "id": 41631,
        "nodeType": "PragmaDirective",
        "src": "33:24:96",
        "literals": [
          "solidity",
          "^",
          "0.8",
          ".14"
        ]
      },
      {
        "id": 41632,
        "nodeType": "ImportDirective",
        "src": "59:53:96",
        "absolutePath": "src/core/interfaces/callback/ITradeCallback.sol",
        "file": "core/interfaces/callback/ITradeCallback.sol",
        "nameLocation": "-1:-1:-1",
        "scope": 41867,
        "sourceUnit": 33596,
        "symbolAliases": [],
        "unitAlias": ""
      },
      {
        "id": 41633,
        "nodeType": "ImportDirective",
        "src": "113:51:96",
        "absolutePath": "src/core/interfaces/battle/IBattleActions.sol",
        "file": "core/interfaces/battle/IBattleActions.sol",
        "nameLocation": "-1:-1:-1",
        "scope": 41867,
        "sourceUnit": 33355,
        "symbolAliases": [],
        "unitAlias": ""
      },
      {
        "id": 41634,
        "nodeType": "ImportDirective",
        "src": "165:32:96",
        "absolutePath": "src/core/libs/TickMath.sol",
        "file": "core/libs/TickMath.sol",
        "nameLocation": "-1:-1:-1",
        "scope": 41867,
        "sourceUnit": 37447,
        "symbolAliases": [],
        "unitAlias": ""
      },
      {
        "id": 41866,
        "nodeType": "ContractDefinition",
        "src": "199:2128:96",
        "nodes": [
          {
            "id": 41734,
            "nodeType": "FunctionDefinition",
            "src": "239:964:96",
            "body": {
              "id": 41733,
              "nodeType": "Block",
              "src": "435:768:96",
              "statements": [
                {
                  "assignments": [
                    41652
                  ],
                  "declarations": [
                    {
                      "constant": false,
                      "id": 41652,
                      "mutability": "mutable",
                      "name": "spend",
                      "nameLocation": "451:5:96",
                      "nodeType": "VariableDeclaration",
                      "scope": 41733,
                      "src": "446:10:96",
                      "stateVariable": false,
                      "storageLocation": "default",
                      "typeDescriptions": {
                        "typeIdentifier": "t_uint256",
                        "typeString": "uint256"
                      },
                      "typeName": {
                        "id": 41651,
                        "name": "uint",
                        "nodeType": "ElementaryTypeName",
                        "src": "446:4:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      },
                      "visibility": "internal"
                    }
                  ],
                  "id": 41653,
                  "nodeType": "VariableDeclarationStatement",
                  "src": "446:10:96"
                },
                {
                  "assignments": [
                    41655
                  ],
                  "declarations": [
                    {
                      "constant": false,
                      "id": 41655,
                      "mutability": "mutable",
                      "name": "get",
                      "nameLocation": "471:3:96",
                      "nodeType": "VariableDeclaration",
                      "scope": 41733,
                      "src": "466:8:96",
                      "stateVariable": false,
                      "storageLocation": "default",
                      "typeDescriptions": {
                        "typeIdentifier": "t_uint256",
                        "typeString": "uint256"
                      },
                      "typeName": {
                        "id": 41654,
                        "name": "uint",
                        "nodeType": "ElementaryTypeName",
                        "src": "466:4:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      },
                      "visibility": "internal"
                    }
                  ],
                  "id": 41656,
                  "nodeType": "VariableDeclarationStatement",
                  "src": "466:8:96"
                },
                {
                  "condition": {
                    "commonType": {
                      "typeIdentifier": "t_enum$_TradeAction_$32892",
                      "typeString": "enum TradeAction"
                    },
                    "id": 41660,
                    "isConstant": false,
                    "isLValue": false,
                    "isPure": false,
                    "lValueRequested": false,
                    "leftExpression": {
                      "id": 41657,
                      "name": "action",
                      "nodeType": "Identifier",
                      "overloadedDeclarations": [],
                      "referencedDeclaration": 41639,
                      "src": "488:6:96",
                      "typeDescriptions": {
                        "typeIdentifier": "t_enum$_TradeAction_$32892",
                        "typeString": "enum TradeAction"
                      }
                    },
                    "nodeType": "BinaryOperation",
                    "operator": "==",
                    "rightExpression": {
                      "expression": {
                        "id": 41658,
                        "name": "TradeAction",
                        "nodeType": "Identifier",
                        "overloadedDeclarations": [],
                        "referencedDeclaration": 32892,
                        "src": "498:11:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_type$_t_enum$_TradeAction_$32892_$",
                          "typeString": "type(enum TradeAction)"
                        }
                      },
                      "id": 41659,
                      "isConstant": false,
                      "isLValue": false,
                      "isPure": true,
                      "lValueRequested": false,
                      "memberLocation": "510:9:96",
                      "memberName": "BUY_SPEAR",
                      "nodeType": "MemberAccess",
                      "referencedDeclaration": 32888,
                      "src": "498:21:96",
                      "typeDescriptions": {
                        "typeIdentifier": "t_enum$_TradeAction_$32892",
                        "typeString": "enum TradeAction"
                      }
                    },
                    "src": "488:31:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_bool",
                      "typeString": "bool"
                    }
                  },
                  "falseBody": {
                    "condition": {
                      "commonType": {
                        "typeIdentifier": "t_enum$_TradeAction_$32892",
                        "typeString": "enum TradeAction"
                      },
                      "id": 41679,
                      "isConstant": false,
                      "isLValue": false,
                      "isPure": false,
                      "lValueRequested": false,
                      "leftExpression": {
                        "id": 41676,
                        "name": "action",
                        "nodeType": "Identifier",
                        "overloadedDeclarations": [],
                        "referencedDeclaration": 41639,
                        "src": "636:6:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_enum$_TradeAction_$32892",
                          "typeString": "enum TradeAction"
                        }
                      },
                      "nodeType": "BinaryOperation",
                      "operator": "==",
                      "rightExpression": {
                        "expression": {
                          "id": 41677,
                          "name": "TradeAction",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 32892,
                          "src": "646:11:96",
                          "typeDescriptions": {
                            "typeIdentifier": "t_type$_t_enum$_TradeAction_$32892_$",
                            "typeString": "type(enum TradeAction)"
                          }
                        },
                        "id": 41678,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": true,
                        "lValueRequested": false,
                        "memberLocation": "658:10:96",
                        "memberName": "BUY_SHIELD",
                        "nodeType": "MemberAccess",
                        "referencedDeclaration": 32890,
                        "src": "646:22:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_enum$_TradeAction_$32892",
                          "typeString": "enum TradeAction"
                        }
                      },
                      "src": "636:32:96",
                      "typeDescriptions": {
                        "typeIdentifier": "t_bool",
                        "typeString": "bool"
                      }
                    },
                    "falseBody": {
                      "condition": {
                        "commonType": {
                          "typeIdentifier": "t_enum$_TradeAction_$32892",
                          "typeString": "enum TradeAction"
                        },
                        "id": 41698,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "lValueRequested": false,
                        "leftExpression": {
                          "id": 41695,
                          "name": "action",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 41639,
                          "src": "786:6:96",
                          "typeDescriptions": {
                            "typeIdentifier": "t_enum$_TradeAction_$32892",
                            "typeString": "enum TradeAction"
                          }
                        },
                        "nodeType": "BinaryOperation",
                        "operator": "==",
                        "rightExpression": {
                          "expression": {
                            "id": 41696,
                            "name": "TradeAction",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": 32892,
                            "src": "796:11:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_type$_t_enum$_TradeAction_$32892_$",
                              "typeString": "type(enum TradeAction)"
                            }
                          },
                          "id": 41697,
                          "isConstant": false,
                          "isLValue": false,
                          "isPure": true,
                          "lValueRequested": false,
                          "memberLocation": "808:10:96",
                          "memberName": "SELL_SPEAR",
                          "nodeType": "MemberAccess",
                          "referencedDeclaration": 32889,
                          "src": "796:22:96",
                          "typeDescriptions": {
                            "typeIdentifier": "t_enum$_TradeAction_$32892",
                            "typeString": "enum TradeAction"
                          }
                        },
                        "src": "786:32:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_bool",
                          "typeString": "bool"
                        }
                      },
                      "falseBody": {
                        "id": 41728,
                        "nodeType": "Block",
                        "src": "931:103:96",
                        "statements": [
                          {
                            "expression": {
                              "id": 41719,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": false,
                              "lValueRequested": false,
                              "leftHandSide": {
                                "id": 41714,
                                "name": "spend",
                                "nodeType": "Identifier",
                                "overloadedDeclarations": [],
                                "referencedDeclaration": 41652,
                                "src": "945:5:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_uint256",
                                  "typeString": "uint256"
                                }
                              },
                              "nodeType": "Assignment",
                              "operator": "=",
                              "rightHandSide": {
                                "arguments": [
                                  {
                                    "id": 41717,
                                    "name": "amountShieldDelta",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 41643,
                                    "src": "958:17:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_int256",
                                      "typeString": "int256"
                                    }
                                  }
                                ],
                                "expression": {
                                  "argumentTypes": [
                                    {
                                      "typeIdentifier": "t_int256",
                                      "typeString": "int256"
                                    }
                                  ],
                                  "id": 41716,
                                  "isConstant": false,
                                  "isLValue": false,
                                  "isPure": true,
                                  "lValueRequested": false,
                                  "nodeType": "ElementaryTypeNameExpression",
                                  "src": "953:4:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_type$_t_uint256_$",
                                    "typeString": "type(uint256)"
                                  },
                                  "typeName": {
                                    "id": 41715,
                                    "name": "uint",
                                    "nodeType": "ElementaryTypeName",
                                    "src": "953:4:96",
                                    "typeDescriptions": {}
                                  }
                                },
                                "id": 41718,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": false,
                                "kind": "typeConversion",
                                "lValueRequested": false,
                                "nameLocations": [],
                                "names": [],
                                "nodeType": "FunctionCall",
                                "src": "953:23:96",
                                "tryCall": false,
                                "typeDescriptions": {
                                  "typeIdentifier": "t_uint256",
                                  "typeString": "uint256"
                                }
                              },
                              "src": "945:31:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "id": 41720,
                            "nodeType": "ExpressionStatement",
                            "src": "945:31:96"
                          },
                          {
                            "expression": {
                              "id": 41726,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": false,
                              "lValueRequested": false,
                              "leftHandSide": {
                                "id": 41721,
                                "name": "get",
                                "nodeType": "Identifier",
                                "overloadedDeclarations": [],
                                "referencedDeclaration": 41655,
                                "src": "990:3:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_uint256",
                                  "typeString": "uint256"
                                }
                              },
                              "nodeType": "Assignment",
                              "operator": "=",
                              "rightHandSide": {
                                "arguments": [
                                  {
                                    "id": 41724,
                                    "name": "amountCollateralDelta",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 41645,
                                    "src": "1001:21:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_int256",
                                      "typeString": "int256"
                                    }
                                  }
                                ],
                                "expression": {
                                  "argumentTypes": [
                                    {
                                      "typeIdentifier": "t_int256",
                                      "typeString": "int256"
                                    }
                                  ],
                                  "id": 41723,
                                  "isConstant": false,
                                  "isLValue": false,
                                  "isPure": true,
                                  "lValueRequested": false,
                                  "nodeType": "ElementaryTypeNameExpression",
                                  "src": "996:4:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_type$_t_uint256_$",
                                    "typeString": "type(uint256)"
                                  },
                                  "typeName": {
                                    "id": 41722,
                                    "name": "uint",
                                    "nodeType": "ElementaryTypeName",
                                    "src": "996:4:96",
                                    "typeDescriptions": {}
                                  }
                                },
                                "id": 41725,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": false,
                                "kind": "typeConversion",
                                "lValueRequested": false,
                                "nameLocations": [],
                                "names": [],
                                "nodeType": "FunctionCall",
                                "src": "996:27:96",
                                "tryCall": false,
                                "typeDescriptions": {
                                  "typeIdentifier": "t_uint256",
                                  "typeString": "uint256"
                                }
                              },
                              "src": "990:33:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "id": 41727,
                            "nodeType": "ExpressionStatement",
                            "src": "990:33:96"
                          }
                        ]
                      },
                      "id": 41729,
                      "nodeType": "IfStatement",
                      "src": "782:252:96",
                      "trueBody": {
                        "id": 41713,
                        "nodeType": "Block",
                        "src": "820:105:96",
                        "statements": [
                          {
                            "expression": {
                              "id": 41704,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": false,
                              "lValueRequested": false,
                              "leftHandSide": {
                                "id": 41699,
                                "name": "spend",
                                "nodeType": "Identifier",
                                "overloadedDeclarations": [],
                                "referencedDeclaration": 41652,
                                "src": "834:5:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_uint256",
                                  "typeString": "uint256"
                                }
                              },
                              "nodeType": "Assignment",
                              "operator": "=",
                              "rightHandSide": {
                                "arguments": [
                                  {
                                    "id": 41702,
                                    "name": "amountSpearDelta",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 41641,
                                    "src": "847:16:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_int256",
                                      "typeString": "int256"
                                    }
                                  }
                                ],
                                "expression": {
                                  "argumentTypes": [
                                    {
                                      "typeIdentifier": "t_int256",
                                      "typeString": "int256"
                                    }
                                  ],
                                  "id": 41701,
                                  "isConstant": false,
                                  "isLValue": false,
                                  "isPure": true,
                                  "lValueRequested": false,
                                  "nodeType": "ElementaryTypeNameExpression",
                                  "src": "842:4:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_type$_t_uint256_$",
                                    "typeString": "type(uint256)"
                                  },
                                  "typeName": {
                                    "id": 41700,
                                    "name": "uint",
                                    "nodeType": "ElementaryTypeName",
                                    "src": "842:4:96",
                                    "typeDescriptions": {}
                                  }
                                },
                                "id": 41703,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": false,
                                "kind": "typeConversion",
                                "lValueRequested": false,
                                "nameLocations": [],
                                "names": [],
                                "nodeType": "FunctionCall",
                                "src": "842:22:96",
                                "tryCall": false,
                                "typeDescriptions": {
                                  "typeIdentifier": "t_uint256",
                                  "typeString": "uint256"
                                }
                              },
                              "src": "834:30:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "id": 41705,
                            "nodeType": "ExpressionStatement",
                            "src": "834:30:96"
                          },
                          {
                            "expression": {
                              "id": 41711,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": false,
                              "lValueRequested": false,
                              "leftHandSide": {
                                "id": 41706,
                                "name": "get",
                                "nodeType": "Identifier",
                                "overloadedDeclarations": [],
                                "referencedDeclaration": 41655,
                                "src": "878:3:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_uint256",
                                  "typeString": "uint256"
                                }
                              },
                              "nodeType": "Assignment",
                              "operator": "=",
                              "rightHandSide": {
                                "arguments": [
                                  {
                                    "id": 41709,
                                    "name": "amountCollateralDelta",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 41645,
                                    "src": "892:21:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_int256",
                                      "typeString": "int256"
                                    }
                                  }
                                ],
                                "expression": {
                                  "argumentTypes": [
                                    {
                                      "typeIdentifier": "t_int256",
                                      "typeString": "int256"
                                    }
                                  ],
                                  "id": 41708,
                                  "isConstant": false,
                                  "isLValue": false,
                                  "isPure": true,
                                  "lValueRequested": false,
                                  "nodeType": "ElementaryTypeNameExpression",
                                  "src": "884:7:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_type$_t_uint256_$",
                                    "typeString": "type(uint256)"
                                  },
                                  "typeName": {
                                    "id": 41707,
                                    "name": "uint256",
                                    "nodeType": "ElementaryTypeName",
                                    "src": "884:7:96",
                                    "typeDescriptions": {}
                                  }
                                },
                                "id": 41710,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": false,
                                "kind": "typeConversion",
                                "lValueRequested": false,
                                "nameLocations": [],
                                "names": [],
                                "nodeType": "FunctionCall",
                                "src": "884:30:96",
                                "tryCall": false,
                                "typeDescriptions": {
                                  "typeIdentifier": "t_uint256",
                                  "typeString": "uint256"
                                }
                              },
                              "src": "878:36:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "id": 41712,
                            "nodeType": "ExpressionStatement",
                            "src": "878:36:96"
                          }
                        ]
                      }
                    },
                    "id": 41730,
                    "nodeType": "IfStatement",
                    "src": "632:402:96",
                    "trueBody": {
                      "id": 41694,
                      "nodeType": "Block",
                      "src": "670:106:96",
                      "statements": [
                        {
                          "expression": {
                            "id": 41685,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "leftHandSide": {
                              "id": 41680,
                              "name": "spend",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 41652,
                              "src": "684:5:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "nodeType": "Assignment",
                            "operator": "=",
                            "rightHandSide": {
                              "arguments": [
                                {
                                  "id": 41683,
                                  "name": "amountCollateralDelta",
                                  "nodeType": "Identifier",
                                  "overloadedDeclarations": [],
                                  "referencedDeclaration": 41645,
                                  "src": "697:21:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_int256",
                                    "typeString": "int256"
                                  }
                                }
                              ],
                              "expression": {
                                "argumentTypes": [
                                  {
                                    "typeIdentifier": "t_int256",
                                    "typeString": "int256"
                                  }
                                ],
                                "id": 41682,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": true,
                                "lValueRequested": false,
                                "nodeType": "ElementaryTypeNameExpression",
                                "src": "692:4:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_type$_t_uint256_$",
                                  "typeString": "type(uint256)"
                                },
                                "typeName": {
                                  "id": 41681,
                                  "name": "uint",
                                  "nodeType": "ElementaryTypeName",
                                  "src": "692:4:96",
                                  "typeDescriptions": {}
                                }
                              },
                              "id": 41684,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": false,
                              "kind": "typeConversion",
                              "lValueRequested": false,
                              "nameLocations": [],
                              "names": [],
                              "nodeType": "FunctionCall",
                              "src": "692:27:96",
                              "tryCall": false,
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "src": "684:35:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          },
                          "id": 41686,
                          "nodeType": "ExpressionStatement",
                          "src": "684:35:96"
                        },
                        {
                          "expression": {
                            "id": 41692,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "leftHandSide": {
                              "id": 41687,
                              "name": "get",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 41655,
                              "src": "733:3:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "nodeType": "Assignment",
                            "operator": "=",
                            "rightHandSide": {
                              "arguments": [
                                {
                                  "id": 41690,
                                  "name": "amountShieldDelta",
                                  "nodeType": "Identifier",
                                  "overloadedDeclarations": [],
                                  "referencedDeclaration": 41643,
                                  "src": "747:17:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_int256",
                                    "typeString": "int256"
                                  }
                                }
                              ],
                              "expression": {
                                "argumentTypes": [
                                  {
                                    "typeIdentifier": "t_int256",
                                    "typeString": "int256"
                                  }
                                ],
                                "id": 41689,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": true,
                                "lValueRequested": false,
                                "nodeType": "ElementaryTypeNameExpression",
                                "src": "739:7:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_type$_t_uint256_$",
                                  "typeString": "type(uint256)"
                                },
                                "typeName": {
                                  "id": 41688,
                                  "name": "uint256",
                                  "nodeType": "ElementaryTypeName",
                                  "src": "739:7:96",
                                  "typeDescriptions": {}
                                }
                              },
                              "id": 41691,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": false,
                              "kind": "typeConversion",
                              "lValueRequested": false,
                              "nameLocations": [],
                              "names": [],
                              "nodeType": "FunctionCall",
                              "src": "739:26:96",
                              "tryCall": false,
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "src": "733:32:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          },
                          "id": 41693,
                          "nodeType": "ExpressionStatement",
                          "src": "733:32:96"
                        }
                      ]
                    }
                  },
                  "id": 41731,
                  "nodeType": "IfStatement",
                  "src": "484:550:96",
                  "trueBody": {
                    "id": 41675,
                    "nodeType": "Block",
                    "src": "521:105:96",
                    "statements": [
                      {
                        "expression": {
                          "id": 41666,
                          "isConstant": false,
                          "isLValue": false,
                          "isPure": false,
                          "lValueRequested": false,
                          "leftHandSide": {
                            "id": 41661,
                            "name": "spend",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": 41652,
                            "src": "535:5:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          },
                          "nodeType": "Assignment",
                          "operator": "=",
                          "rightHandSide": {
                            "arguments": [
                              {
                                "id": 41664,
                                "name": "amountCollateralDelta",
                                "nodeType": "Identifier",
                                "overloadedDeclarations": [],
                                "referencedDeclaration": 41645,
                                "src": "548:21:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_int256",
                                  "typeString": "int256"
                                }
                              }
                            ],
                            "expression": {
                              "argumentTypes": [
                                {
                                  "typeIdentifier": "t_int256",
                                  "typeString": "int256"
                                }
                              ],
                              "id": 41663,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": true,
                              "lValueRequested": false,
                              "nodeType": "ElementaryTypeNameExpression",
                              "src": "543:4:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_type$_t_uint256_$",
                                "typeString": "type(uint256)"
                              },
                              "typeName": {
                                "id": 41662,
                                "name": "uint",
                                "nodeType": "ElementaryTypeName",
                                "src": "543:4:96",
                                "typeDescriptions": {}
                              }
                            },
                            "id": 41665,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "kind": "typeConversion",
                            "lValueRequested": false,
                            "nameLocations": [],
                            "names": [],
                            "nodeType": "FunctionCall",
                            "src": "543:27:96",
                            "tryCall": false,
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          },
                          "src": "535:35:96",
                          "typeDescriptions": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          }
                        },
                        "id": 41667,
                        "nodeType": "ExpressionStatement",
                        "src": "535:35:96"
                      },
                      {
                        "expression": {
                          "id": 41673,
                          "isConstant": false,
                          "isLValue": false,
                          "isPure": false,
                          "lValueRequested": false,
                          "leftHandSide": {
                            "id": 41668,
                            "name": "get",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": 41655,
                            "src": "584:3:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          },
                          "nodeType": "Assignment",
                          "operator": "=",
                          "rightHandSide": {
                            "arguments": [
                              {
                                "id": 41671,
                                "name": "amountSpearDelta",
                                "nodeType": "Identifier",
                                "overloadedDeclarations": [],
                                "referencedDeclaration": 41641,
                                "src": "598:16:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_int256",
                                  "typeString": "int256"
                                }
                              }
                            ],
                            "expression": {
                              "argumentTypes": [
                                {
                                  "typeIdentifier": "t_int256",
                                  "typeString": "int256"
                                }
                              ],
                              "id": 41670,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": true,
                              "lValueRequested": false,
                              "nodeType": "ElementaryTypeNameExpression",
                              "src": "590:7:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_type$_t_uint256_$",
                                "typeString": "type(uint256)"
                              },
                              "typeName": {
                                "id": 41669,
                                "name": "uint256",
                                "nodeType": "ElementaryTypeName",
                                "src": "590:7:96",
                                "typeDescriptions": {}
                              }
                            },
                            "id": 41672,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "kind": "typeConversion",
                            "lValueRequested": false,
                            "nameLocations": [],
                            "names": [],
                            "nodeType": "FunctionCall",
                            "src": "590:25:96",
                            "tryCall": false,
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          },
                          "src": "584:31:96",
                          "typeDescriptions": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          }
                        },
                        "id": 41674,
                        "nodeType": "ExpressionStatement",
                        "src": "584:31:96"
                      }
                    ]
                  }
                },
                {
                  "AST": {
                    "nodeType": "YulBlock",
                    "src": "1052:145:96",
                    "statements": [
                      {
                        "nodeType": "YulVariableDeclaration",
                        "src": "1066:22:96",
                        "value": {
                          "arguments": [
                            {
                              "kind": "number",
                              "nodeType": "YulLiteral",
                              "src": "1083:4:96",
                              "type": "",
                              "value": "0x40"
                            }
                          ],
                          "functionName": {
                            "name": "mload",
                            "nodeType": "YulIdentifier",
                            "src": "1077:5:96"
                          },
                          "nodeType": "YulFunctionCall",
                          "src": "1077:11:96"
                        },
                        "variables": [
                          {
                            "name": "ptr",
                            "nodeType": "YulTypedName",
                            "src": "1070:3:96",
                            "type": ""
                          }
                        ]
                      },
                      {
                        "expression": {
                          "arguments": [
                            {
                              "name": "ptr",
                              "nodeType": "YulIdentifier",
                              "src": "1108:3:96"
                            },
                            {
                              "name": "spend",
                              "nodeType": "YulIdentifier",
                              "src": "1113:5:96"
                            }
                          ],
                          "functionName": {
                            "name": "mstore",
                            "nodeType": "YulIdentifier",
                            "src": "1101:6:96"
                          },
                          "nodeType": "YulFunctionCall",
                          "src": "1101:18:96"
                        },
                        "nodeType": "YulExpressionStatement",
                        "src": "1101:18:96"
                      },
                      {
                        "expression": {
                          "arguments": [
                            {
                              "arguments": [
                                {
                                  "name": "ptr",
                                  "nodeType": "YulIdentifier",
                                  "src": "1143:3:96"
                                },
                                {
                                  "kind": "number",
                                  "nodeType": "YulLiteral",
                                  "src": "1148:4:96",
                                  "type": "",
                                  "value": "0x20"
                                }
                              ],
                              "functionName": {
                                "name": "add",
                                "nodeType": "YulIdentifier",
                                "src": "1139:3:96"
                              },
                              "nodeType": "YulFunctionCall",
                              "src": "1139:14:96"
                            },
                            {
                              "name": "get",
                              "nodeType": "YulIdentifier",
                              "src": "1155:3:96"
                            }
                          ],
                          "functionName": {
                            "name": "mstore",
                            "nodeType": "YulIdentifier",
                            "src": "1132:6:96"
                          },
                          "nodeType": "YulFunctionCall",
                          "src": "1132:27:96"
                        },
                        "nodeType": "YulExpressionStatement",
                        "src": "1132:27:96"
                      },
                      {
                        "expression": {
                          "arguments": [
                            {
                              "name": "ptr",
                              "nodeType": "YulIdentifier",
                              "src": "1179:3:96"
                            },
                            {
                              "kind": "number",
                              "nodeType": "YulLiteral",
                              "src": "1184:2:96",
                              "type": "",
                              "value": "64"
                            }
                          ],
                          "functionName": {
                            "name": "revert",
                            "nodeType": "YulIdentifier",
                            "src": "1172:6:96"
                          },
                          "nodeType": "YulFunctionCall",
                          "src": "1172:15:96"
                        },
                        "nodeType": "YulExpressionStatement",
                        "src": "1172:15:96"
                      }
                    ]
                  },
                  "evmVersion": "london",
                  "externalReferences": [
                    {
                      "declaration": 41655,
                      "isOffset": false,
                      "isSlot": false,
                      "src": "1155:3:96",
                      "valueSize": 1
                    },
                    {
                      "declaration": 41652,
                      "isOffset": false,
                      "isSlot": false,
                      "src": "1113:5:96",
                      "valueSize": 1
                    }
                  ],
                  "id": 41732,
                  "nodeType": "InlineAssembly",
                  "src": "1043:154:96"
                }
              ]
            },
            "baseFunctions": [
              33594
            ],
            "functionSelector": "5d2652af",
            "implemented": true,
            "kind": "function",
            "modifiers": [],
            "name": "tradeCallback",
            "nameLocation": "248:13:96",
            "overrides": {
              "id": 41649,
              "nodeType": "OverrideSpecifier",
              "overrides": [],
              "src": "422:8:96"
            },
            "parameters": {
              "id": 41648,
              "nodeType": "ParameterList",
              "parameters": [
                {
                  "constant": false,
                  "id": 41639,
                  "mutability": "mutable",
                  "name": "action",
                  "nameLocation": "274:6:96",
                  "nodeType": "VariableDeclaration",
                  "scope": 41734,
                  "src": "262:18:96",
                  "stateVariable": false,
                  "storageLocation": "default",
                  "typeDescriptions": {
                    "typeIdentifier": "t_enum$_TradeAction_$32892",
                    "typeString": "enum TradeAction"
                  },
                  "typeName": {
                    "id": 41638,
                    "nodeType": "UserDefinedTypeName",
                    "pathNode": {
                      "id": 41637,
                      "name": "TradeAction",
                      "nameLocations": [
                        "262:11:96"
                      ],
                      "nodeType": "IdentifierPath",
                      "referencedDeclaration": 32892,
                      "src": "262:11:96"
                    },
                    "referencedDeclaration": 32892,
                    "src": "262:11:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_enum$_TradeAction_$32892",
                      "typeString": "enum TradeAction"
                    }
                  },
                  "visibility": "internal"
                },
                {
                  "constant": false,
                  "id": 41641,
                  "mutability": "mutable",
                  "name": "amountSpearDelta",
                  "nameLocation": "289:16:96",
                  "nodeType": "VariableDeclaration",
                  "scope": 41734,
                  "src": "282:23:96",
                  "stateVariable": false,
                  "storageLocation": "default",
                  "typeDescriptions": {
                    "typeIdentifier": "t_int256",
                    "typeString": "int256"
                  },
                  "typeName": {
                    "id": 41640,
                    "name": "int256",
                    "nodeType": "ElementaryTypeName",
                    "src": "282:6:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_int256",
                      "typeString": "int256"
                    }
                  },
                  "visibility": "internal"
                },
                {
                  "constant": false,
                  "id": 41643,
                  "mutability": "mutable",
                  "name": "amountShieldDelta",
                  "nameLocation": "314:17:96",
                  "nodeType": "VariableDeclaration",
                  "scope": 41734,
                  "src": "307:24:96",
                  "stateVariable": false,
                  "storageLocation": "default",
                  "typeDescriptions": {
                    "typeIdentifier": "t_int256",
                    "typeString": "int256"
                  },
                  "typeName": {
                    "id": 41642,
                    "name": "int256",
                    "nodeType": "ElementaryTypeName",
                    "src": "307:6:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_int256",
                      "typeString": "int256"
                    }
                  },
                  "visibility": "internal"
                },
                {
                  "constant": false,
                  "id": 41645,
                  "mutability": "mutable",
                  "name": "amountCollateralDelta",
                  "nameLocation": "340:21:96",
                  "nodeType": "VariableDeclaration",
                  "scope": 41734,
                  "src": "333:28:96",
                  "stateVariable": false,
                  "storageLocation": "default",
                  "typeDescriptions": {
                    "typeIdentifier": "t_int256",
                    "typeString": "int256"
                  },
                  "typeName": {
                    "id": 41644,
                    "name": "int256",
                    "nodeType": "ElementaryTypeName",
                    "src": "333:6:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_int256",
                      "typeString": "int256"
                    }
                  },
                  "visibility": "internal"
                },
                {
                  "constant": false,
                  "id": 41647,
                  "mutability": "mutable",
                  "name": "data",
                  "nameLocation": "378:4:96",
                  "nodeType": "VariableDeclaration",
                  "scope": 41734,
                  "src": "363:19:96",
                  "stateVariable": false,
                  "storageLocation": "calldata",
                  "typeDescriptions": {
                    "typeIdentifier": "t_bytes_calldata_ptr",
                    "typeString": "bytes"
                  },
                  "typeName": {
                    "id": 41646,
                    "name": "bytes",
                    "nodeType": "ElementaryTypeName",
                    "src": "363:5:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_bytes_storage_ptr",
                      "typeString": "bytes"
                    }
                  },
                  "visibility": "internal"
                }
              ],
              "src": "261:122:96"
            },
            "returnParameters": {
              "id": 41650,
              "nodeType": "ParameterList",
              "parameters": [],
              "src": "435:0:96"
            },
            "scope": 41866,
            "stateMutability": "pure",
            "virtual": false,
            "visibility": "external"
          },
          {
            "id": 41777,
            "nodeType": "FunctionDefinition",
            "src": "1209:392:96",
            "body": {
              "id": 41776,
              "nodeType": "Block",
              "src": "1288:313:96",
              "statements": [
                {
                  "condition": {
                    "commonType": {
                      "typeIdentifier": "t_uint256",
                      "typeString": "uint256"
                    },
                    "id": 41744,
                    "isConstant": false,
                    "isLValue": false,
                    "isPure": false,
                    "lValueRequested": false,
                    "leftExpression": {
                      "expression": {
                        "id": 41741,
                        "name": "reason",
                        "nodeType": "Identifier",
                        "overloadedDeclarations": [],
                        "referencedDeclaration": 41736,
                        "src": "1302:6:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_bytes_memory_ptr",
                          "typeString": "bytes memory"
                        }
                      },
                      "id": 41742,
                      "isConstant": false,
                      "isLValue": false,
                      "isPure": false,
                      "lValueRequested": false,
                      "memberLocation": "1309:6:96",
                      "memberName": "length",
                      "nodeType": "MemberAccess",
                      "src": "1302:13:96",
                      "typeDescriptions": {
                        "typeIdentifier": "t_uint256",
                        "typeString": "uint256"
                      }
                    },
                    "nodeType": "BinaryOperation",
                    "operator": "!=",
                    "rightExpression": {
                      "hexValue": "3332",
                      "id": 41743,
                      "isConstant": false,
                      "isLValue": false,
                      "isPure": true,
                      "kind": "number",
                      "lValueRequested": false,
                      "nodeType": "Literal",
                      "src": "1319:2:96",
                      "typeDescriptions": {
                        "typeIdentifier": "t_rational_32_by_1",
                        "typeString": "int_const 32"
                      },
                      "value": "32"
                    },
                    "src": "1302:19:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_bool",
                      "typeString": "bool"
                    }
                  },
                  "id": 41767,
                  "nodeType": "IfStatement",
                  "src": "1298:251:96",
                  "trueBody": {
                    "id": 41766,
                    "nodeType": "Block",
                    "src": "1323:226:96",
                    "statements": [
                      {
                        "condition": {
                          "commonType": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          },
                          "id": 41748,
                          "isConstant": false,
                          "isLValue": false,
                          "isPure": false,
                          "lValueRequested": false,
                          "leftExpression": {
                            "expression": {
                              "id": 41745,
                              "name": "reason",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 41736,
                              "src": "1341:6:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_bytes_memory_ptr",
                                "typeString": "bytes memory"
                              }
                            },
                            "id": 41746,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "memberLocation": "1348:6:96",
                            "memberName": "length",
                            "nodeType": "MemberAccess",
                            "src": "1341:13:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          },
                          "nodeType": "BinaryOperation",
                          "operator": "<",
                          "rightExpression": {
                            "hexValue": "3638",
                            "id": 41747,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": true,
                            "kind": "number",
                            "lValueRequested": false,
                            "nodeType": "Literal",
                            "src": "1357:2:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_rational_68_by_1",
                              "typeString": "int_const 68"
                            },
                            "value": "68"
                          },
                          "src": "1341:18:96",
                          "typeDescriptions": {
                            "typeIdentifier": "t_bool",
                            "typeString": "bool"
                          }
                        },
                        "id": 41754,
                        "nodeType": "IfStatement",
                        "src": "1337:71:96",
                        "trueBody": {
                          "id": 41753,
                          "nodeType": "Block",
                          "src": "1361:47:96",
                          "statements": [
                            {
                              "expression": {
                                "arguments": [
                                  {
                                    "hexValue": "77686174",
                                    "id": 41750,
                                    "isConstant": false,
                                    "isLValue": false,
                                    "isPure": true,
                                    "kind": "string",
                                    "lValueRequested": false,
                                    "nodeType": "Literal",
                                    "src": "1386:6:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_stringliteral_0c5385b0d3124870eb014e9af752d99fc89980d4e882a9550936b8bff06990a3",
                                      "typeString": "literal_string \"what\""
                                    },
                                    "value": "what"
                                  }
                                ],
                                "expression": {
                                  "argumentTypes": [
                                    {
                                      "typeIdentifier": "t_stringliteral_0c5385b0d3124870eb014e9af752d99fc89980d4e882a9550936b8bff06990a3",
                                      "typeString": "literal_string \"what\""
                                    }
                                  ],
                                  "id": 41749,
                                  "name": "revert",
                                  "nodeType": "Identifier",
                                  "overloadedDeclarations": [
                                    -19,
                                    -19
                                  ],
                                  "referencedDeclaration": -19,
                                  "src": "1379:6:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_function_revert_pure$_t_string_memory_ptr_$returns$__$",
                                    "typeString": "function (string memory) pure"
                                  }
                                },
                                "id": 41751,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": false,
                                "kind": "functionCall",
                                "lValueRequested": false,
                                "nameLocations": [],
                                "names": [],
                                "nodeType": "FunctionCall",
                                "src": "1379:14:96",
                                "tryCall": false,
                                "typeDescriptions": {
                                  "typeIdentifier": "t_tuple$__$",
                                  "typeString": "tuple()"
                                }
                              },
                              "id": 41752,
                              "nodeType": "ExpressionStatement",
                              "src": "1379:14:96"
                            }
                          ]
                        }
                      },
                      {
                        "AST": {
                          "nodeType": "YulBlock",
                          "src": "1430:59:96",
                          "statements": [
                            {
                              "nodeType": "YulAssignment",
                              "src": "1448:27:96",
                              "value": {
                                "arguments": [
                                  {
                                    "name": "reason",
                                    "nodeType": "YulIdentifier",
                                    "src": "1462:6:96"
                                  },
                                  {
                                    "kind": "number",
                                    "nodeType": "YulLiteral",
                                    "src": "1470:4:96",
                                    "type": "",
                                    "value": "0x04"
                                  }
                                ],
                                "functionName": {
                                  "name": "add",
                                  "nodeType": "YulIdentifier",
                                  "src": "1458:3:96"
                                },
                                "nodeType": "YulFunctionCall",
                                "src": "1458:17:96"
                              },
                              "variableNames": [
                                {
                                  "name": "reason",
                                  "nodeType": "YulIdentifier",
                                  "src": "1448:6:96"
                                }
                              ]
                            }
                          ]
                        },
                        "evmVersion": "london",
                        "externalReferences": [
                          {
                            "declaration": 41736,
                            "isOffset": false,
                            "isSlot": false,
                            "src": "1448:6:96",
                            "valueSize": 1
                          },
                          {
                            "declaration": 41736,
                            "isOffset": false,
                            "isSlot": false,
                            "src": "1462:6:96",
                            "valueSize": 1
                          }
                        ],
                        "id": 41755,
                        "nodeType": "InlineAssembly",
                        "src": "1421:68:96"
                      },
                      {
                        "expression": {
                          "arguments": [
                            {
                              "arguments": [
                                {
                                  "id": 41759,
                                  "name": "reason",
                                  "nodeType": "Identifier",
                                  "overloadedDeclarations": [],
                                  "referencedDeclaration": 41736,
                                  "src": "1520:6:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_bytes_memory_ptr",
                                    "typeString": "bytes memory"
                                  }
                                },
                                {
                                  "components": [
                                    {
                                      "id": 41761,
                                      "isConstant": false,
                                      "isLValue": false,
                                      "isPure": true,
                                      "lValueRequested": false,
                                      "nodeType": "ElementaryTypeNameExpression",
                                      "src": "1529:6:96",
                                      "typeDescriptions": {
                                        "typeIdentifier": "t_type$_t_string_storage_ptr_$",
                                        "typeString": "type(string storage pointer)"
                                      },
                                      "typeName": {
                                        "id": 41760,
                                        "name": "string",
                                        "nodeType": "ElementaryTypeName",
                                        "src": "1529:6:96",
                                        "typeDescriptions": {}
                                      }
                                    }
                                  ],
                                  "id": 41762,
                                  "isConstant": false,
                                  "isInlineArray": false,
                                  "isLValue": false,
                                  "isPure": true,
                                  "lValueRequested": false,
                                  "nodeType": "TupleExpression",
                                  "src": "1528:8:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_type$_t_string_storage_ptr_$",
                                    "typeString": "type(string storage pointer)"
                                  }
                                }
                              ],
                              "expression": {
                                "argumentTypes": [
                                  {
                                    "typeIdentifier": "t_bytes_memory_ptr",
                                    "typeString": "bytes memory"
                                  },
                                  {
                                    "typeIdentifier": "t_type$_t_string_storage_ptr_$",
                                    "typeString": "type(string storage pointer)"
                                  }
                                ],
                                "expression": {
                                  "id": 41757,
                                  "name": "abi",
                                  "nodeType": "Identifier",
                                  "overloadedDeclarations": [],
                                  "referencedDeclaration": -1,
                                  "src": "1509:3:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_magic_abi",
                                    "typeString": "abi"
                                  }
                                },
                                "id": 41758,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": true,
                                "lValueRequested": false,
                                "memberLocation": "1513:6:96",
                                "memberName": "decode",
                                "nodeType": "MemberAccess",
                                "src": "1509:10:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_function_abidecode_pure$__$returns$__$",
                                  "typeString": "function () pure"
                                }
                              },
                              "id": 41763,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": false,
                              "kind": "functionCall",
                              "lValueRequested": false,
                              "nameLocations": [],
                              "names": [],
                              "nodeType": "FunctionCall",
                              "src": "1509:28:96",
                              "tryCall": false,
                              "typeDescriptions": {
                                "typeIdentifier": "t_string_memory_ptr",
                                "typeString": "string memory"
                              }
                            }
                          ],
                          "expression": {
                            "argumentTypes": [
                              {
                                "typeIdentifier": "t_string_memory_ptr",
                                "typeString": "string memory"
                              }
                            ],
                            "id": 41756,
                            "name": "revert",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [
                              -19,
                              -19
                            ],
                            "referencedDeclaration": -19,
                            "src": "1502:6:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_function_revert_pure$_t_string_memory_ptr_$returns$__$",
                              "typeString": "function (string memory) pure"
                            }
                          },
                          "id": 41764,
                          "isConstant": false,
                          "isLValue": false,
                          "isPure": false,
                          "kind": "functionCall",
                          "lValueRequested": false,
                          "nameLocations": [],
                          "names": [],
                          "nodeType": "FunctionCall",
                          "src": "1502:36:96",
                          "tryCall": false,
                          "typeDescriptions": {
                            "typeIdentifier": "t_tuple$__$",
                            "typeString": "tuple()"
                          }
                        },
                        "id": 41765,
                        "nodeType": "ExpressionStatement",
                        "src": "1502:36:96"
                      }
                    ]
                  }
                },
                {
                  "expression": {
                    "arguments": [
                      {
                        "id": 41770,
                        "name": "reason",
                        "nodeType": "Identifier",
                        "overloadedDeclarations": [],
                        "referencedDeclaration": 41736,
                        "src": "1576:6:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_bytes_memory_ptr",
                          "typeString": "bytes memory"
                        }
                      },
                      {
                        "components": [
                          {
                            "id": 41772,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": true,
                            "lValueRequested": false,
                            "nodeType": "ElementaryTypeNameExpression",
                            "src": "1585:7:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_type$_t_uint256_$",
                              "typeString": "type(uint256)"
                            },
                            "typeName": {
                              "id": 41771,
                              "name": "uint256",
                              "nodeType": "ElementaryTypeName",
                              "src": "1585:7:96",
                              "typeDescriptions": {}
                            }
                          }
                        ],
                        "id": 41773,
                        "isConstant": false,
                        "isInlineArray": false,
                        "isLValue": false,
                        "isPure": true,
                        "lValueRequested": false,
                        "nodeType": "TupleExpression",
                        "src": "1584:9:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_type$_t_uint256_$",
                          "typeString": "type(uint256)"
                        }
                      }
                    ],
                    "expression": {
                      "argumentTypes": [
                        {
                          "typeIdentifier": "t_bytes_memory_ptr",
                          "typeString": "bytes memory"
                        },
                        {
                          "typeIdentifier": "t_type$_t_uint256_$",
                          "typeString": "type(uint256)"
                        }
                      ],
                      "expression": {
                        "id": 41768,
                        "name": "abi",
                        "nodeType": "Identifier",
                        "overloadedDeclarations": [],
                        "referencedDeclaration": -1,
                        "src": "1565:3:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_magic_abi",
                          "typeString": "abi"
                        }
                      },
                      "id": 41769,
                      "isConstant": false,
                      "isLValue": false,
                      "isPure": true,
                      "lValueRequested": false,
                      "memberLocation": "1569:6:96",
                      "memberName": "decode",
                      "nodeType": "MemberAccess",
                      "src": "1565:10:96",
                      "typeDescriptions": {
                        "typeIdentifier": "t_function_abidecode_pure$__$returns$__$",
                        "typeString": "function () pure"
                      }
                    },
                    "id": 41774,
                    "isConstant": false,
                    "isLValue": false,
                    "isPure": false,
                    "kind": "functionCall",
                    "lValueRequested": false,
                    "nameLocations": [],
                    "names": [],
                    "nodeType": "FunctionCall",
                    "src": "1565:29:96",
                    "tryCall": false,
                    "typeDescriptions": {
                      "typeIdentifier": "t_uint256",
                      "typeString": "uint256"
                    }
                  },
                  "functionReturnParameters": 41740,
                  "id": 41775,
                  "nodeType": "Return",
                  "src": "1558:36:96"
                }
              ]
            },
            "implemented": true,
            "kind": "function",
            "modifiers": [],
            "name": "parseRevertReason",
            "nameLocation": "1218:17:96",
            "parameters": {
              "id": 41737,
              "nodeType": "ParameterList",
              "parameters": [
                {
                  "constant": false,
                  "id": 41736,
                  "mutability": "mutable",
                  "name": "reason",
                  "nameLocation": "1249:6:96",
                  "nodeType": "VariableDeclaration",
                  "scope": 41777,
                  "src": "1236:19:96",
                  "stateVariable": false,
                  "storageLocation": "memory",
                  "typeDescriptions": {
                    "typeIdentifier": "t_bytes_memory_ptr",
                    "typeString": "bytes"
                  },
                  "typeName": {
                    "id": 41735,
                    "name": "bytes",
                    "nodeType": "ElementaryTypeName",
                    "src": "1236:5:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_bytes_storage_ptr",
                      "typeString": "bytes"
                    }
                  },
                  "visibility": "internal"
                }
              ],
              "src": "1235:21:96"
            },
            "returnParameters": {
              "id": 41740,
              "nodeType": "ParameterList",
              "parameters": [
                {
                  "constant": false,
                  "id": 41739,
                  "mutability": "mutable",
                  "name": "",
                  "nameLocation": "-1:-1:-1",
                  "nodeType": "VariableDeclaration",
                  "scope": 41777,
                  "src": "1279:7:96",
                  "stateVariable": false,
                  "storageLocation": "default",
                  "typeDescriptions": {
                    "typeIdentifier": "t_uint256",
                    "typeString": "uint256"
                  },
                  "typeName": {
                    "id": 41738,
                    "name": "uint256",
                    "nodeType": "ElementaryTypeName",
                    "src": "1279:7:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_uint256",
                      "typeString": "uint256"
                    }
                  },
                  "visibility": "internal"
                }
              ],
              "src": "1278:9:96"
            },
            "scope": 41866,
            "stateMutability": "pure",
            "virtual": false,
            "visibility": "private"
          },
          {
            "id": 41865,
            "nodeType": "FunctionDefinition",
            "src": "1607:718:96",
            "body": {
              "id": 41864,
              "nodeType": "Block",
              "src": "1729:596:96",
              "statements": [
                {
                  "expression": {
                    "id": 41796,
                    "isConstant": false,
                    "isLValue": false,
                    "isPure": false,
                    "lValueRequested": false,
                    "leftHandSide": {
                      "expression": {
                        "id": 41789,
                        "name": "params",
                        "nodeType": "Identifier",
                        "overloadedDeclarations": [],
                        "referencedDeclaration": 41780,
                        "src": "1739:6:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_struct$_TradeParamsBattle_$38153_memory_ptr",
                          "typeString": "struct TradeParamsBattle memory"
                        }
                      },
                      "id": 41791,
                      "isConstant": false,
                      "isLValue": true,
                      "isPure": false,
                      "lValueRequested": true,
                      "memberLocation": "1746:9:96",
                      "memberName": "recipient",
                      "nodeType": "MemberAccess",
                      "referencedDeclaration": 38143,
                      "src": "1739:16:96",
                      "typeDescriptions": {
                        "typeIdentifier": "t_address",
                        "typeString": "address"
                      }
                    },
                    "nodeType": "Assignment",
                    "operator": "=",
                    "rightHandSide": {
                      "arguments": [
                        {
                          "id": 41794,
                          "name": "this",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": -28,
                          "src": "1766:4:96",
                          "typeDescriptions": {
                            "typeIdentifier": "t_contract$_Quoter_$41866",
                            "typeString": "contract Quoter"
                          }
                        }
                      ],
                      "expression": {
                        "argumentTypes": [
                          {
                            "typeIdentifier": "t_contract$_Quoter_$41866",
                            "typeString": "contract Quoter"
                          }
                        ],
                        "id": 41793,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": true,
                        "lValueRequested": false,
                        "nodeType": "ElementaryTypeNameExpression",
                        "src": "1758:7:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_type$_t_address_$",
                          "typeString": "type(address)"
                        },
                        "typeName": {
                          "id": 41792,
                          "name": "address",
                          "nodeType": "ElementaryTypeName",
                          "src": "1758:7:96",
                          "typeDescriptions": {}
                        }
                      },
                      "id": 41795,
                      "isConstant": false,
                      "isLValue": false,
                      "isPure": false,
                      "kind": "typeConversion",
                      "lValueRequested": false,
                      "nameLocations": [],
                      "names": [],
                      "nodeType": "FunctionCall",
                      "src": "1758:13:96",
                      "tryCall": false,
                      "typeDescriptions": {
                        "typeIdentifier": "t_address",
                        "typeString": "address"
                      }
                    },
                    "src": "1739:32:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_address",
                      "typeString": "address"
                    }
                  },
                  "id": 41797,
                  "nodeType": "ExpressionStatement",
                  "src": "1739:32:96"
                },
                {
                  "condition": {
                    "commonType": {
                      "typeIdentifier": "t_uint160",
                      "typeString": "uint160"
                    },
                    "id": 41801,
                    "isConstant": false,
                    "isLValue": false,
                    "isPure": false,
                    "lValueRequested": false,
                    "leftExpression": {
                      "expression": {
                        "id": 41798,
                        "name": "params",
                        "nodeType": "Identifier",
                        "overloadedDeclarations": [],
                        "referencedDeclaration": 41780,
                        "src": "1785:6:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_struct$_TradeParamsBattle_$38153_memory_ptr",
                          "typeString": "struct TradeParamsBattle memory"
                        }
                      },
                      "id": 41799,
                      "isConstant": false,
                      "isLValue": true,
                      "isPure": false,
                      "lValueRequested": false,
                      "memberLocation": "1792:17:96",
                      "memberName": "sqrtPriceLimitX96",
                      "nodeType": "MemberAccess",
                      "referencedDeclaration": 38150,
                      "src": "1785:24:96",
                      "typeDescriptions": {
                        "typeIdentifier": "t_uint160",
                        "typeString": "uint160"
                      }
                    },
                    "nodeType": "BinaryOperation",
                    "operator": "==",
                    "rightExpression": {
                      "hexValue": "30",
                      "id": 41800,
                      "isConstant": false,
                      "isLValue": false,
                      "isPure": true,
                      "kind": "number",
                      "lValueRequested": false,
                      "nodeType": "Literal",
                      "src": "1813:1:96",
                      "typeDescriptions": {
                        "typeIdentifier": "t_rational_0_by_1",
                        "typeString": "int_const 0"
                      },
                      "value": "0"
                    },
                    "src": "1785:29:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_bool",
                      "typeString": "bool"
                    }
                  },
                  "id": 41835,
                  "nodeType": "IfStatement",
                  "src": "1781:358:96",
                  "trueBody": {
                    "id": 41834,
                    "nodeType": "Block",
                    "src": "1816:323:96",
                    "statements": [
                      {
                        "condition": {
                          "commonType": {
                            "typeIdentifier": "t_bool",
                            "typeString": "bool"
                          },
                          "id": 41812,
                          "isConstant": false,
                          "isLValue": false,
                          "isPure": false,
                          "lValueRequested": false,
                          "leftExpression": {
                            "commonType": {
                              "typeIdentifier": "t_enum$_TradeAction_$32892",
                              "typeString": "enum TradeAction"
                            },
                            "id": 41806,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "leftExpression": {
                              "expression": {
                                "id": 41802,
                                "name": "params",
                                "nodeType": "Identifier",
                                "overloadedDeclarations": [],
                                "referencedDeclaration": 41780,
                                "src": "1834:6:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_struct$_TradeParamsBattle_$38153_memory_ptr",
                                  "typeString": "struct TradeParamsBattle memory"
                                }
                              },
                              "id": 41803,
                              "isConstant": false,
                              "isLValue": true,
                              "isPure": false,
                              "lValueRequested": false,
                              "memberLocation": "1841:6:96",
                              "memberName": "action",
                              "nodeType": "MemberAccess",
                              "referencedDeclaration": 38146,
                              "src": "1834:13:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_enum$_TradeAction_$32892",
                                "typeString": "enum TradeAction"
                              }
                            },
                            "nodeType": "BinaryOperation",
                            "operator": "==",
                            "rightExpression": {
                              "expression": {
                                "id": 41804,
                                "name": "TradeAction",
                                "nodeType": "Identifier",
                                "overloadedDeclarations": [],
                                "referencedDeclaration": 32892,
                                "src": "1851:11:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_type$_t_enum$_TradeAction_$32892_$",
                                  "typeString": "type(enum TradeAction)"
                                }
                              },
                              "id": 41805,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": true,
                              "lValueRequested": false,
                              "memberLocation": "1863:9:96",
                              "memberName": "BUY_SPEAR",
                              "nodeType": "MemberAccess",
                              "referencedDeclaration": 32888,
                              "src": "1851:21:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_enum$_TradeAction_$32892",
                                "typeString": "enum TradeAction"
                              }
                            },
                            "src": "1834:38:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_bool",
                              "typeString": "bool"
                            }
                          },
                          "nodeType": "BinaryOperation",
                          "operator": "||",
                          "rightExpression": {
                            "commonType": {
                              "typeIdentifier": "t_enum$_TradeAction_$32892",
                              "typeString": "enum TradeAction"
                            },
                            "id": 41811,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "leftExpression": {
                              "expression": {
                                "id": 41807,
                                "name": "params",
                                "nodeType": "Identifier",
                                "overloadedDeclarations": [],
                                "referencedDeclaration": 41780,
                                "src": "1876:6:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_struct$_TradeParamsBattle_$38153_memory_ptr",
                                  "typeString": "struct TradeParamsBattle memory"
                                }
                              },
                              "id": 41808,
                              "isConstant": false,
                              "isLValue": true,
                              "isPure": false,
                              "lValueRequested": false,
                              "memberLocation": "1883:6:96",
                              "memberName": "action",
                              "nodeType": "MemberAccess",
                              "referencedDeclaration": 38146,
                              "src": "1876:13:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_enum$_TradeAction_$32892",
                                "typeString": "enum TradeAction"
                              }
                            },
                            "nodeType": "BinaryOperation",
                            "operator": "==",
                            "rightExpression": {
                              "expression": {
                                "id": 41809,
                                "name": "TradeAction",
                                "nodeType": "Identifier",
                                "overloadedDeclarations": [],
                                "referencedDeclaration": 32892,
                                "src": "1893:11:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_type$_t_enum$_TradeAction_$32892_$",
                                  "typeString": "type(enum TradeAction)"
                                }
                              },
                              "id": 41810,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": true,
                              "lValueRequested": false,
                              "memberLocation": "1905:11:96",
                              "memberName": "SELL_SHIELD",
                              "nodeType": "MemberAccess",
                              "referencedDeclaration": 32891,
                              "src": "1893:23:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_enum$_TradeAction_$32892",
                                "typeString": "enum TradeAction"
                              }
                            },
                            "src": "1876:40:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_bool",
                              "typeString": "bool"
                            }
                          },
                          "src": "1834:82:96",
                          "typeDescriptions": {
                            "typeIdentifier": "t_bool",
                            "typeString": "bool"
                          }
                        },
                        "falseBody": {
                          "id": 41832,
                          "nodeType": "Block",
                          "src": "2042:87:96",
                          "statements": [
                            {
                              "expression": {
                                "id": 41830,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": false,
                                "lValueRequested": false,
                                "leftHandSide": {
                                  "expression": {
                                    "id": 41823,
                                    "name": "params",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 41780,
                                    "src": "2060:6:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_struct$_TradeParamsBattle_$38153_memory_ptr",
                                      "typeString": "struct TradeParamsBattle memory"
                                    }
                                  },
                                  "id": 41825,
                                  "isConstant": false,
                                  "isLValue": true,
                                  "isPure": false,
                                  "lValueRequested": true,
                                  "memberLocation": "2067:17:96",
                                  "memberName": "sqrtPriceLimitX96",
                                  "nodeType": "MemberAccess",
                                  "referencedDeclaration": 38150,
                                  "src": "2060:24:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_uint160",
                                    "typeString": "uint160"
                                  }
                                },
                                "nodeType": "Assignment",
                                "operator": "=",
                                "rightHandSide": {
                                  "commonType": {
                                    "typeIdentifier": "t_uint160",
                                    "typeString": "uint160"
                                  },
                                  "id": 41829,
                                  "isConstant": false,
                                  "isLValue": false,
                                  "isPure": true,
                                  "lValueRequested": false,
                                  "leftExpression": {
                                    "expression": {
                                      "id": 41826,
                                      "name": "TickMath",
                                      "nodeType": "Identifier",
                                      "overloadedDeclarations": [],
                                      "referencedDeclaration": 37446,
                                      "src": "2087:8:96",
                                      "typeDescriptions": {
                                        "typeIdentifier": "t_type$_t_contract$_TickMath_$37446_$",
                                        "typeString": "type(library TickMath)"
                                      }
                                    },
                                    "id": 41827,
                                    "isConstant": false,
                                    "isLValue": false,
                                    "isPure": true,
                                    "lValueRequested": false,
                                    "memberLocation": "2096:14:96",
                                    "memberName": "MIN_SQRT_RATIO",
                                    "nodeType": "MemberAccess",
                                    "referencedDeclaration": 36895,
                                    "src": "2087:23:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_uint160",
                                      "typeString": "uint160"
                                    }
                                  },
                                  "nodeType": "BinaryOperation",
                                  "operator": "+",
                                  "rightExpression": {
                                    "hexValue": "30",
                                    "id": 41828,
                                    "isConstant": false,
                                    "isLValue": false,
                                    "isPure": true,
                                    "kind": "number",
                                    "lValueRequested": false,
                                    "nodeType": "Literal",
                                    "src": "2113:1:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_rational_0_by_1",
                                      "typeString": "int_const 0"
                                    },
                                    "value": "0"
                                  },
                                  "src": "2087:27:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_uint160",
                                    "typeString": "uint160"
                                  }
                                },
                                "src": "2060:54:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_uint160",
                                  "typeString": "uint160"
                                }
                              },
                              "id": 41831,
                              "nodeType": "ExpressionStatement",
                              "src": "2060:54:96"
                            }
                          ]
                        },
                        "id": 41833,
                        "nodeType": "IfStatement",
                        "src": "1830:299:96",
                        "trueBody": {
                          "id": 41822,
                          "nodeType": "Block",
                          "src": "1918:118:96",
                          "statements": [
                            {
                              "expression": {
                                "id": 41820,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": false,
                                "lValueRequested": false,
                                "leftHandSide": {
                                  "expression": {
                                    "id": 41813,
                                    "name": "params",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 41780,
                                    "src": "1967:6:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_struct$_TradeParamsBattle_$38153_memory_ptr",
                                      "typeString": "struct TradeParamsBattle memory"
                                    }
                                  },
                                  "id": 41815,
                                  "isConstant": false,
                                  "isLValue": true,
                                  "isPure": false,
                                  "lValueRequested": true,
                                  "memberLocation": "1974:17:96",
                                  "memberName": "sqrtPriceLimitX96",
                                  "nodeType": "MemberAccess",
                                  "referencedDeclaration": 38150,
                                  "src": "1967:24:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_uint160",
                                    "typeString": "uint160"
                                  }
                                },
                                "nodeType": "Assignment",
                                "operator": "=",
                                "rightHandSide": {
                                  "commonType": {
                                    "typeIdentifier": "t_uint160",
                                    "typeString": "uint160"
                                  },
                                  "id": 41819,
                                  "isConstant": false,
                                  "isLValue": false,
                                  "isPure": true,
                                  "lValueRequested": false,
                                  "leftExpression": {
                                    "expression": {
                                      "id": 41816,
                                      "name": "TickMath",
                                      "nodeType": "Identifier",
                                      "overloadedDeclarations": [],
                                      "referencedDeclaration": 37446,
                                      "src": "1994:8:96",
                                      "typeDescriptions": {
                                        "typeIdentifier": "t_type$_t_contract$_TickMath_$37446_$",
                                        "typeString": "type(library TickMath)"
                                      }
                                    },
                                    "id": 41817,
                                    "isConstant": false,
                                    "isLValue": false,
                                    "isPure": true,
                                    "lValueRequested": false,
                                    "memberLocation": "2003:14:96",
                                    "memberName": "MAX_SQRT_RATIO",
                                    "nodeType": "MemberAccess",
                                    "referencedDeclaration": 36899,
                                    "src": "1994:23:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_uint160",
                                      "typeString": "uint160"
                                    }
                                  },
                                  "nodeType": "BinaryOperation",
                                  "operator": "-",
                                  "rightExpression": {
                                    "hexValue": "30",
                                    "id": 41818,
                                    "isConstant": false,
                                    "isLValue": false,
                                    "isPure": true,
                                    "kind": "number",
                                    "lValueRequested": false,
                                    "nodeType": "Literal",
                                    "src": "2020:1:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_rational_0_by_1",
                                      "typeString": "int_const 0"
                                    },
                                    "value": "0"
                                  },
                                  "src": "1994:27:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_uint160",
                                    "typeString": "uint160"
                                  }
                                },
                                "src": "1967:54:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_uint160",
                                  "typeString": "uint160"
                                }
                              },
                              "id": 41821,
                              "nodeType": "ExpressionStatement",
                              "src": "1967:54:96"
                            }
                          ]
                        }
                      }
                    ]
                  }
                },
                {
                  "clauses": [
                    {
                      "block": {
                        "id": 41842,
                        "nodeType": "Block",
                        "src": "2215:2:96",
                        "statements": []
                      },
                      "errorName": "",
                      "id": 41843,
                      "nodeType": "TryCatchClause",
                      "src": "2215:2:96"
                    },
                    {
                      "block": {
                        "id": 41861,
                        "nodeType": "Block",
                        "src": "2246:73:96",
                        "statements": [
                          {
                            "expression": {
                              "id": 41859,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": false,
                              "lValueRequested": false,
                              "leftHandSide": {
                                "components": [
                                  {
                                    "id": 41847,
                                    "name": "spend",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 41785,
                                    "src": "2261:5:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_uint256",
                                      "typeString": "uint256"
                                    }
                                  },
                                  {
                                    "id": 41848,
                                    "name": "get",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 41787,
                                    "src": "2268:3:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_uint256",
                                      "typeString": "uint256"
                                    }
                                  }
                                ],
                                "id": 41849,
                                "isConstant": false,
                                "isInlineArray": false,
                                "isLValue": true,
                                "isPure": false,
                                "lValueRequested": true,
                                "nodeType": "TupleExpression",
                                "src": "2260:12:96",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_tuple$_t_uint256_$_t_uint256_$",
                                  "typeString": "tuple(uint256,uint256)"
                                }
                              },
                              "nodeType": "Assignment",
                              "operator": "=",
                              "rightHandSide": {
                                "arguments": [
                                  {
                                    "id": 41852,
                                    "name": "reason",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 41845,
                                    "src": "2287:6:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_bytes_memory_ptr",
                                      "typeString": "bytes memory"
                                    }
                                  },
                                  {
                                    "components": [
                                      {
                                        "id": 41854,
                                        "isConstant": false,
                                        "isLValue": false,
                                        "isPure": true,
                                        "lValueRequested": false,
                                        "nodeType": "ElementaryTypeNameExpression",
                                        "src": "2296:4:96",
                                        "typeDescriptions": {
                                          "typeIdentifier": "t_type$_t_uint256_$",
                                          "typeString": "type(uint256)"
                                        },
                                        "typeName": {
                                          "id": 41853,
                                          "name": "uint",
                                          "nodeType": "ElementaryTypeName",
                                          "src": "2296:4:96",
                                          "typeDescriptions": {}
                                        }
                                      },
                                      {
                                        "id": 41856,
                                        "isConstant": false,
                                        "isLValue": false,
                                        "isPure": true,
                                        "lValueRequested": false,
                                        "nodeType": "ElementaryTypeNameExpression",
                                        "src": "2302:4:96",
                                        "typeDescriptions": {
                                          "typeIdentifier": "t_type$_t_uint256_$",
                                          "typeString": "type(uint256)"
                                        },
                                        "typeName": {
                                          "id": 41855,
                                          "name": "uint",
                                          "nodeType": "ElementaryTypeName",
                                          "src": "2302:4:96",
                                          "typeDescriptions": {}
                                        }
                                      }
                                    ],
                                    "id": 41857,
                                    "isConstant": false,
                                    "isInlineArray": false,
                                    "isLValue": false,
                                    "isPure": true,
                                    "lValueRequested": false,
                                    "nodeType": "TupleExpression",
                                    "src": "2295:12:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_tuple$_t_type$_t_uint256_$_$_t_type$_t_uint256_$_$",
                                      "typeString": "tuple(type(uint256),type(uint256))"
                                    }
                                  }
                                ],
                                "expression": {
                                  "argumentTypes": [
                                    {
                                      "typeIdentifier": "t_bytes_memory_ptr",
                                      "typeString": "bytes memory"
                                    },
                                    {
                                      "typeIdentifier": "t_tuple$_t_type$_t_uint256_$_$_t_type$_t_uint256_$_$",
                                      "typeString": "tuple(type(uint256),type(uint256))"
                                    }
                                  ],
                                  "expression": {
                                    "id": 41850,
                                    "name": "abi",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": -1,
                                    "src": "2276:3:96",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_magic_abi",
                                      "typeString": "abi"
                                    }
                                  },
                                  "id": 41851,
                                  "isConstant": false,
                                  "isLValue": false,
                                  "isPure": true,
                                  "lValueRequested": false,
                                  "memberLocation": "2280:6:96",
                                  "memberName": "decode",
                                  "nodeType": "MemberAccess",
                                  "src": "2276:10:96",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_function_abidecode_pure$__$returns$__$",
                                    "typeString": "function () pure"
                                  }
                                },
                                "id": 41858,
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": false,
                                "kind": "functionCall",
                                "lValueRequested": false,
                                "nameLocations": [],
                                "names": [],
                                "nodeType": "FunctionCall",
                                "src": "2276:32:96",
                                "tryCall": false,
                                "typeDescriptions": {
                                  "typeIdentifier": "t_tuple$_t_uint256_$_t_uint256_$",
                                  "typeString": "tuple(uint256,uint256)"
                                }
                              },
                              "src": "2260:48:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_tuple$__$",
                                "typeString": "tuple()"
                              }
                            },
                            "id": 41860,
                            "nodeType": "ExpressionStatement",
                            "src": "2260:48:96"
                          }
                        ]
                      },
                      "errorName": "",
                      "id": 41862,
                      "nodeType": "TryCatchClause",
                      "parameters": {
                        "id": 41846,
                        "nodeType": "ParameterList",
                        "parameters": [
                          {
                            "constant": false,
                            "id": 41845,
                            "mutability": "mutable",
                            "name": "reason",
                            "nameLocation": "2238:6:96",
                            "nodeType": "VariableDeclaration",
                            "scope": 41862,
                            "src": "2225:19:96",
                            "stateVariable": false,
                            "storageLocation": "memory",
                            "typeDescriptions": {
                              "typeIdentifier": "t_bytes_memory_ptr",
                              "typeString": "bytes"
                            },
                            "typeName": {
                              "id": 41844,
                              "name": "bytes",
                              "nodeType": "ElementaryTypeName",
                              "src": "2225:5:96",
                              "typeDescriptions": {
                                "typeIdentifier": "t_bytes_storage_ptr",
                                "typeString": "bytes"
                              }
                            },
                            "visibility": "internal"
                          }
                        ],
                        "src": "2224:21:96"
                      },
                      "src": "2218:101:96"
                    }
                  ],
                  "externalCall": {
                    "arguments": [
                      {
                        "id": 41840,
                        "name": "params",
                        "nodeType": "Identifier",
                        "overloadedDeclarations": [],
                        "referencedDeclaration": 41780,
                        "src": "2198:6:96",
                        "typeDescriptions": {
                          "typeIdentifier": "t_struct$_TradeParamsBattle_$38153_memory_ptr",
                          "typeString": "struct TradeParamsBattle memory"
                        }
                      }
                    ],
                    "expression": {
                      "argumentTypes": [
                        {
                          "typeIdentifier": "t_struct$_TradeParamsBattle_$38153_memory_ptr",
                          "typeString": "struct TradeParamsBattle memory"
                        }
                      ],
                      "expression": {
                        "arguments": [
                          {
                            "id": 41837,
                            "name": "battleAddr",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": 41782,
                            "src": "2180:10:96",
                            "typeDescriptions": {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            }
                          }
                        ],
                        "expression": {
                          "argumentTypes": [
                            {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            }
                          ],
                          "id": 41836,
                          "name": "IBattleActions",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 33354,
                          "src": "2165:14:96",
                          "typeDescriptions": {
                            "typeIdentifier": "t_type$_t_contract$_IBattleActions_$33354_$",
                            "typeString": "type(contract IBattleActions)"
                          }
                        },
                        "id": 41838,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "kind": "typeConversion",
                        "lValueRequested": false,
                        "nameLocations": [],
                        "names": [],
                        "nodeType": "FunctionCall",
                        "src": "2165:26:96",
                        "tryCall": false,
                        "typeDescriptions": {
                          "typeIdentifier": "t_contract$_IBattleActions_$33354",
                          "typeString": "contract IBattleActions"
                        }
                      },
                      "id": 41839,
                      "isConstant": false,
                      "isLValue": false,
                      "isPure": false,
                      "lValueRequested": false,
                      "memberLocation": "2192:5:96",
                      "memberName": "trade",
                      "nodeType": "MemberAccess",
                      "referencedDeclaration": 33333,
                      "src": "2165:32:96",
                      "typeDescriptions": {
                        "typeIdentifier": "t_function_external_nonpayable$_t_struct$_TradeParamsBattle_$38153_memory_ptr_$returns$_t_struct$_TradeReturnValuesBattle_$38166_memory_ptr_$",
                        "typeString": "function (struct TradeParamsBattle memory) external returns (struct TradeReturnValuesBattle memory)"
                      }
                    },
                    "id": 41841,
                    "isConstant": false,
                    "isLValue": false,
                    "isPure": false,
                    "kind": "functionCall",
                    "lValueRequested": false,
                    "nameLocations": [],
                    "names": [],
                    "nodeType": "FunctionCall",
                    "src": "2165:40:96",
                    "tryCall": true,
                    "typeDescriptions": {
                      "typeIdentifier": "t_struct$_TradeReturnValuesBattle_$38166_memory_ptr",
                      "typeString": "struct TradeReturnValuesBattle memory"
                    }
                  },
                  "id": 41863,
                  "nodeType": "TryStatement",
                  "src": "2148:171:96"
                }
              ]
            },
            "functionSelector": "64c2c158",
            "implemented": true,
            "kind": "function",
            "modifiers": [],
            "name": "quoteExactInput",
            "nameLocation": "1616:15:96",
            "parameters": {
              "id": 41783,
              "nodeType": "ParameterList",
              "parameters": [
                {
                  "constant": false,
                  "id": 41780,
                  "mutability": "mutable",
                  "name": "params",
                  "nameLocation": "1657:6:96",
                  "nodeType": "VariableDeclaration",
                  "scope": 41865,
                  "src": "1632:31:96",
                  "stateVariable": false,
                  "storageLocation": "memory",
                  "typeDescriptions": {
                    "typeIdentifier": "t_struct$_TradeParamsBattle_$38153_memory_ptr",
                    "typeString": "struct TradeParamsBattle"
                  },
                  "typeName": {
                    "id": 41779,
                    "nodeType": "UserDefinedTypeName",
                    "pathNode": {
                      "id": 41778,
                      "name": "TradeParamsBattle",
                      "nameLocations": [
                        "1632:17:96"
                      ],
                      "nodeType": "IdentifierPath",
                      "referencedDeclaration": 38153,
                      "src": "1632:17:96"
                    },
                    "referencedDeclaration": 38153,
                    "src": "1632:17:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_struct$_TradeParamsBattle_$38153_storage_ptr",
                      "typeString": "struct TradeParamsBattle"
                    }
                  },
                  "visibility": "internal"
                },
                {
                  "constant": false,
                  "id": 41782,
                  "mutability": "mutable",
                  "name": "battleAddr",
                  "nameLocation": "1673:10:96",
                  "nodeType": "VariableDeclaration",
                  "scope": 41865,
                  "src": "1665:18:96",
                  "stateVariable": false,
                  "storageLocation": "default",
                  "typeDescriptions": {
                    "typeIdentifier": "t_address",
                    "typeString": "address"
                  },
                  "typeName": {
                    "id": 41781,
                    "name": "address",
                    "nodeType": "ElementaryTypeName",
                    "src": "1665:7:96",
                    "stateMutability": "nonpayable",
                    "typeDescriptions": {
                      "typeIdentifier": "t_address",
                      "typeString": "address"
                    }
                  },
                  "visibility": "internal"
                }
              ],
              "src": "1631:53:96"
            },
            "returnParameters": {
              "id": 41788,
              "nodeType": "ParameterList",
              "parameters": [
                {
                  "constant": false,
                  "id": 41785,
                  "mutability": "mutable",
                  "name": "spend",
                  "nameLocation": "1709:5:96",
                  "nodeType": "VariableDeclaration",
                  "scope": 41865,
                  "src": "1701:13:96",
                  "stateVariable": false,
                  "storageLocation": "default",
                  "typeDescriptions": {
                    "typeIdentifier": "t_uint256",
                    "typeString": "uint256"
                  },
                  "typeName": {
                    "id": 41784,
                    "name": "uint256",
                    "nodeType": "ElementaryTypeName",
                    "src": "1701:7:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_uint256",
                      "typeString": "uint256"
                    }
                  },
                  "visibility": "internal"
                },
                {
                  "constant": false,
                  "id": 41787,
                  "mutability": "mutable",
                  "name": "get",
                  "nameLocation": "1724:3:96",
                  "nodeType": "VariableDeclaration",
                  "scope": 41865,
                  "src": "1716:11:96",
                  "stateVariable": false,
                  "storageLocation": "default",
                  "typeDescriptions": {
                    "typeIdentifier": "t_uint256",
                    "typeString": "uint256"
                  },
                  "typeName": {
                    "id": 41786,
                    "name": "uint256",
                    "nodeType": "ElementaryTypeName",
                    "src": "1716:7:96",
                    "typeDescriptions": {
                      "typeIdentifier": "t_uint256",
                      "typeString": "uint256"
                    }
                  },
                  "visibility": "internal"
                }
              ],
              "src": "1700:28:96"
            },
            "scope": 41866,
            "stateMutability": "nonpayable",
            "virtual": false,
            "visibility": "public"
          }
        ],
        "abstract": false,
        "baseContracts": [
          {
            "baseName": {
              "id": 41635,
              "name": "ITradeCallback",
              "nameLocations": [
                "218:14:96"
              ],
              "nodeType": "IdentifierPath",
              "referencedDeclaration": 33595,
              "src": "218:14:96"
            },
            "id": 41636,
            "nodeType": "InheritanceSpecifier",
            "src": "218:14:96"
          }
        ],
        "canonicalName": "Quoter",
        "contractDependencies": [],
        "contractKind": "contract",
        "fullyImplemented": true,
        "linearizedBaseContracts": [
          41866,
          33595
        ],
        "name": "Quoter",
        "nameLocation": "208:6:96",
        "scope": 41867,
        "usedErrors": []
      }
    ],
    "license": "MIT"
  },
  "id": 96
}
