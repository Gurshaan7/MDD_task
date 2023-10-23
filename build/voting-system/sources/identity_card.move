module my_addrx::identity_card
{

    //==============================================================================================
    // Dependencies
    //==============================================================================================
    use std::signer;
    #[test_only]
    use aptos_framework::account;

    //==============================================================================================
    // Error codes
    //==============================================================================================
    const EResourceAlreadyExists: u64 = 0;

    //==============================================================================================
    // Module Structs
    //==============================================================================================

    /*
        The main resource holding data about user's identity
    */

    struct Identity has key
    {
        //name of the user
        name: vector<u8>,
        //age of the user
        age: u64,
        //gender of the user
        gender: vector<u8>
    }


    //==============================================================================================
    // Functions
    //==============================================================================================


    public fun create_id(account: &signer,n: vector<u8>, a: u64 , g: vector<u8>)
    {
        // TODO: Check if the identity resource exists or not
        //      If exits: then abort with error `EResourceAlreadyExists`
        //      Else: Create a new instance of Identity and move it to the account
        let signer_address = signer::address_of(account);
        
        if(!exists<Identity>(signer_address))   
        {
            let i = Identity {
                name : n ,
                age : a ,
                gender : g       
            };
            move_to(account,i);       
        }

        else                               
        {
            abort EResourceAlreadyExists
        }
    }

    public fun update_id(account: &signer,n: vector<u8>, a: u64 , g: vector<u8>) acquires Identity
    {
        //TODO: Borrow the resource and update its fields

        let signer_address = signer::address_of(account);
        let i = borrow_global_mut<Identity>(signer_address); 
        i.name = n;                                  
        i.age = a;
        i.gender = g;
    }

    //==============================================================================================
    // Tests - DO NOT MODIFY
    //==============================================================================================

    #[test]
    fun test_create_id() acquires Identity {
        let account = account::create_account_for_test(@0x23);
        create_id(&account ,b"Jack" , 15 , b"Male" );
        let identity=borrow_global<Identity>(signer::address_of(&account));
        assert!(identity.name== b"Jack",10);
        assert!(identity.age==15,11);
        assert!(identity.gender==b"Male",12);
    }
    #[test]
    fun test_update_id() acquires Identity {
        let account = account::create_account_for_test(@0x345);
        create_id(&account ,b"Jack" , 15 , b"Male" );
        update_id(&account ,b"Greg" , 17 , b"Male" );
        let identity=borrow_global<Identity>(signer::address_of(&account));
        assert!(identity.name== b"Greg",13);
        assert!(identity.age==17,14);
        assert!(identity.gender==b"Male",15);
    }

}