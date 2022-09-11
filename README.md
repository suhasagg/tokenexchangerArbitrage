# DEX 



![Screenshot from 2022-09-05 09-23-04](https://user-images.githubusercontent.com/3880512/188358181-ff8c90a0-deaf-4704-991a-e3c444466824.png)




![Screenshot from 2022-09-05 08-47-51](https://user-images.githubusercontent.com/3880512/188354396-ab95b885-31e2-4292-ae5c-4742316d94d9.png)





![Screenshot from 2022-09-05 08-48-17](https://user-images.githubusercontent.com/3880512/188354416-fd8bd3c6-8068-4083-9382-4ea618018a96.png)





![Screenshot from 2022-09-05 08-49-25](https://user-images.githubusercontent.com/3880512/188354455-6ee91e73-20c2-4e33-bd49-e1993bea8880.png)




![Screenshot from 2022-09-05 16-40-40](https://user-images.githubusercontent.com/3880512/188438772-d4796062-96ac-4505-9a8a-47ab8095c05e.png)



![Screenshot from 2022-09-05 16-41-16](https://user-images.githubusercontent.com/3880512/188438806-636bb08d-b022-4d3f-827c-6ea4746c3b84.png)




# Price function determining amount of output conversion token for input token.

# EQUATION 
# yOutput = (997 * xInput * (yReserves)) / (xReserves + xInput) / 1000;
  Liquidity reserves of both tokens. 


![Screenshot from 2022-09-05 16-43-18](https://user-images.githubusercontent.com/3880512/188438822-884da94f-7ea2-4102-94cb-61438935d713.png)



![Screenshot from 2022-09-05 16-43-38](https://user-images.githubusercontent.com/3880512/188438840-0dd32af8-10e4-4c16-bfbd-bcdb7fa44a07.png)



![Screenshot from 2022-09-05 16-44-04](https://user-images.githubusercontent.com/3880512/188438864-ff957298-e175-4547-8ef8-0061b97d41d8.png)


#Slippage algorithm - for same amount of axie consecutive ethereum outputted is slightly slipped/less, due to change in reserves.  



![Screenshot from 2022-09-05 16-44-21](https://user-images.githubusercontent.com/3880512/188438891-843718fa-1448-4d02-b89d-ab9e5c46235f.png)



![Screenshot from 2022-09-05 16-44-35](https://user-images.githubusercontent.com/3880512/188438915-f5013f40-a587-4fb4-b650-3893b76ef215.png)



![Screenshot from 2022-09-05 16-44-42](https://user-images.githubusercontent.com/3880512/188438946-a490b965-27d3-4fcc-8299-e1c3f2ea0bc4.png)



![Screenshot from 2022-09-05 16-44-51](https://user-images.githubusercontent.com/3880512/188438970-8159e067-40ca-4670-ad2b-68bab344d1bf.png)



![Screenshot from 2022-09-05 16-45-01](https://user-images.githubusercontent.com/3880512/188438997-15fe6fc6-05f1-48a4-a5a2-88a9656f76d7.png)



![Screenshot from 2022-09-05 18-30-58](https://user-images.githubusercontent.com/3880512/188456243-0e04f956-f829-4fe6-913b-d071f96b41d9.png)



#   133.065 Axies get converted to 136.9639 tapping diffference in exchange rates.


Algorithm 


1)Swap Axies to Eth


2)Swap same amount of Eth to Axies from different exchange.



Repeat this couple of times to increase your current token.


Practically swapping is done across two different exchanges.



![Screenshot from 2022-09-05 18-31-05](https://user-images.githubusercontent.com/3880512/188456288-f4985dbf-bff4-4849-be36-b24d9c69014d.png)



![Screenshot from 2022-09-05 18-32-04](https://user-images.githubusercontent.com/3880512/188456319-a004c480-82bc-4269-aa42-441ca7e57537.png)



![Screenshot from 2022-09-05 18-32-26](https://user-images.githubusercontent.com/3880512/188456347-fdf81940-9b6f-4550-a144-73f22570788f.png)



![Screenshot from 2022-09-05 18-33-06](https://user-images.githubusercontent.com/3880512/188456425-625b32a8-94c4-49ad-b3e6-520249128f6d.png)



![Screenshot from 2022-09-05 18-33-26](https://user-images.githubusercontent.com/3880512/188456453-7cbf63f5-51f7-4d73-be0a-4b2f0f09760d.png)


![Screenshot_20220720-055125](https://user-images.githubusercontent.com/3880512/187183076-e7a14f25-f227-49f2-9abb-fb3858b46951.png)


A simple AMM in Cairo -

Reference - 
https://starknet.io/docs/0.10.0/hello_cairo/amm.html#


let’s move on to the interesting part of the AMM: exchanging tokens. Say that a user wants to get token_b in exchange for token_a of some specified amount (token_a_amount). Let’s denote the amount of tokens they will get by token_b_amount. In the equations below we let:

a and b denote the amounts of token_a and token_b the user swaps,

x and y denote the current balances of token_a and token_b in the AMM (that is, AmmState.token_a_balance and AmmState.token_b_balance).

The AMM formula states that the value of token_a_balance * token_b_balance (that is, x * y) should be preserved. So we have:

<math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
  <mo stretchy="false">(</mo>
  <mi>x</mi>
  <mo>+</mo>
  <mi>a</mi>
  <mo stretchy="false">)</mo>
  <mo>&#x22C5;</mo>
  <mo stretchy="false">(</mo>
  <mi>y</mi>
  <mo>&#x2212;</mo>
  <mi>b</mi>
  <mo stretchy="false">)</mo>
  <mo>=</mo>
  <mi>x</mi>
  <mo>&#x22C5;</mo>
  <mi>y</mi>
  <mo>.</mo>
</math>

Let’s isolate b (as the rest of the values are known):

<math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
  <mi>b</mi>
  <mo>=</mo>
  <mfrac>
    <mrow>
      <mi>y</mi>
      <mo>&#x22C5;</mo>
      <mi>a</mi>
    </mrow>
    <mrow>
      <mi>x</mi>
      <mo>+</mo>
      <mi>a</mi>
    </mrow>
  </mfrac>
  <mo>.</mo>
</math>




