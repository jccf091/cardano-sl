{-# LANGUAGE TemplateHaskell #-}

-- | Types used for managing of transactions
-- and synchronization with database.

module Pos.Txp.Toil.Types
       ( MemPool (..)
       , mpLocalTxs
       , mpLocalTxsSize
       , TxMap
       , BalancesView (..)
       , bvStakes
       , bvTotal
       , UndoMap
       , UtxoModifier
       , TxpModifier (..)
       , txmUtxoModifier
       , txmBalances
       , txmMemPool
       , txmUndos
       ) where

import           Control.Lens        (makeLenses)
import           Data.Default        (Default, def)
import qualified Data.HashMap.Strict as HM
import           Universum

import           Pos.Txp.Core.Types  (TxAux, TxId, TxIn, TxOutAux, TxUndo)
import           Pos.Types           (Coin, StakeholderId, mkCoin)
import qualified Pos.Util.Modifier   as MM

----------------------------------------------------------------------------
-- BalancesView
----------------------------------------------------------------------------

data BalancesView = BalancesView
    { _bvStakes :: !(HashMap StakeholderId Coin)
    , _bvTotal  :: !Coin
    }

makeLenses ''BalancesView

instance Default BalancesView where
    def = BalancesView mempty $ mkCoin 0

----------------------------------------------------------------------------
-- MemPool
----------------------------------------------------------------------------

type TxMap = HashMap TxId TxAux

instance Default TxMap where
    def = mempty

data MemPool = MemPool
    { _mpLocalTxs     :: !TxMap
      -- | @length@ is @O(n)@ for 'HM.HashMap' so we store it explicitly.
    , _mpLocalTxsSize :: !Int
    }

makeLenses ''MemPool

instance Default MemPool where
    def =
        MemPool
        { _mpLocalTxs = HM.empty
        , _mpLocalTxsSize = 0
        }

----------------------------------------------------------------------------
-- TxpModifier
----------------------------------------------------------------------------

type UtxoModifier = MM.MapModifier TxIn TxOutAux
type UndoMap = HashMap TxId TxUndo

instance Default UndoMap where
    def = mempty

data TxpModifier = TxpModifier
    { _txmUtxoModifier :: !UtxoModifier
    , _txmBalances     :: !BalancesView
    , _txmMemPool      :: !MemPool
    , _txmUndos        :: !UndoMap
    }

makeLenses ''TxpModifier
