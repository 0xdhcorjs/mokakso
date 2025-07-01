// getCreationTx.js
const axios = require("axios");

// 환경 변수에서 Etherscan API 키와 조회할 컨트랙트 주소를 읽어옵니다.
const ETHERSCAN_APIKEY = process.env.ETHERSCAN_APIKEY;
const CONTRACT_ADDR    = process.env.CONTRACT_ADDR;

if (!ETHERSCAN_APIKEY || !CONTRACT_ADDR) {
  console.error("❌ 환경 변수가 설정되지 않았습니다. ETHERSCAN_APIKEY, CONTRACT_ADDR를 확인하세요.");
  process.exit(1);
}

async function fetchCreationTx() {
  try {
    // Etherscan API 엔드포인트 (Sepolia 기준)
    const url = `https://api-sepolia.etherscan.io/api`;
    const params = {
      module: "contract",
      action: "getcontractcreation",
      contractaddresses: CONTRACT_ADDR,
      apikey: ETHERSCAN_APIKEY
    };

    const response = await axios.get(url, { params });
    const data = response.data;

    if (data.status !== "1" || !data.result || data.result.length === 0) {
      console.error("❌ 컨트랙트 생성 트랜잭션을 찾지 못했습니다.", data);
      return;
    }

    // result[0].txHash가 생성 트랜잭션 해시
    const creationTxHash = data.result[0].txHash;
    console.log("✅ Contract Creation TX Hash:", creationTxHash);
  } catch (err) {
    console.error("❌ 오류 발생:", err);
  }
}

fetchCreationTx();
