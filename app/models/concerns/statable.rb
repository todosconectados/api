# frozen_string_literal: true

# +Statable+ module.
module Statable
  extend ActiveSupport::Concern
  # enum values for state fields within application
  module State
    AGS   = :ags
    BCN   = :bcn
    BCS   = :bcs
    CAM   = :cam
    CDMX  = :cdmx
    CHP   = :chp
    CHI   = :chi
    COA   = :coa
    COL   = :col
    DUR   = :dur
    GTO   = :gto
    GRO   = :gro
    HGO   = :hgo
    JAL   = :jal
    MEX   = :mex
    MIC   = :mic
    MOR   = :mor
    NAY   = :nay
    NLE   = :nle
    OAX   = :oax
    PUE   = :pue
    QRO   = :qro
    ROO   = :roo
    SLP   = :slp
    SIN   = :sin
    SON   = :son
    TAB   = :tab
    TAM   = :tam
    TLX   = :tlx
    VER   = :ver
    YUC   = :yuc
    ZAC   = :zac
    DATA = {
      AGS => {
        name: 'Aguascalientes'
      },
      BCN => {
        name: 'Baja California Norte'
      },
      BCS => {
        name: 'Baja California Sur'
      },
      CAM => {
        name: 'Campeche'
      },
      CDMX => {
        name: 'Ciudad de México'
      },
      CHP => {
        name: 'Chiapas'
      },
      CHI => {
        name: 'Chihuahua'
      },
      COA => {
        name: 'Coahuila'
      },
      COL => {
        name: 'Colima'
      },
      DUR => {
        name: 'Durango'
      },
      GTO => {
        name: 'Guanajuato'
      },
      GRO => {
        name: 'Guerrero'
      },
      HGO => {
        name: 'Hidalgo'
      },
      JAL => {
        name: 'Jalisco'
      },
      MEX => {
        name: 'Estado de México'
      },
      MIC => {
        name: 'Michoacán'
      },
      MOR => {
        name: 'Morelia'
      },
      NAY => {
        name: 'Nayarit'
      },
      NLE => {
        name: 'Nuevo León'
      },
      OAX => {
        name: 'Oaxaca'
      },
      PUE => {
        name: 'Puebla'
      },
      QRO => {
        name: 'Querétaro'
      },
      ROO => {
        name: 'Quintana Roo'
      },
      SLP => {
        name: 'San Luis Potosí'
      },
      SIN => {
        name: 'Sinaloa'
      },
      SON => {
        name: 'Sonora'
      },
      TAB => {
        name: 'Tabasco'
      },
      TAM => {
        name: 'Tamaulipas'
      },
      TLX => {
        name: 'Tlaxcala'
      },
      VER => {
        name: 'Veracurz'
      },
      YUC => {
        name: 'Yucatán'
      },
      ZAC => {
        name: 'Zacatecas'
      }
    }.freeze
    LIST = [AGS, BCN, BCS, CAM, CDMX, CHP, CHI, COA, COL, DUR, GTO, GRO, HGO,
            JAL, MEX, MIC, MOR, NAY, NLE, OAX, PUE, QRO, ROO, SLP, SIN, SON,
            TAB, TAM, TLX, VER, YUC, ZAC].freeze
  end
  included do
    # declare enum field to +State+ list
    enum state: State::LIST
    # returns the hash information of the +State+ enum with for the +state+
    # attribute
    # @return Hash
    def state_data
      @state_data ||= State::DATA[state.to_sym] if state.present?
    end

    # returns the state name based on the +state_data+ hash information
    # @return String
    def state_name
      @state_name ||= state_data[:name] if state_data.present?
    end

    # overrides the default setter for +address_type+ so assignment is
    # only performed if specified value complies to
    #   State enum.
    # Otherwise, nil is assigned
    # @param val [String] - state value
    # @return nil
    def state=(val)
      self[:state] = self.class.states[val]
    end
  end
end
