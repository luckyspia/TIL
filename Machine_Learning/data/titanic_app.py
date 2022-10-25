
from pycaret.classification import load_model, predict_model
import streamlit as st
import pandas as pd

model = load_model('titanic_model')

st.title('Titanic Survival Prediction App')
Age = st.sidebar.slider("Your Age", 1,75,30)
Fare = st.sidebar.slider("Fare in 1912 $ (See Info)",15,500,40)
SibSp = st.sidebar.selectbox("How many siblings or spouses are travelling with you?",[0,1,2,3,4,5,6,7,8])
Parch = st.sidebar.selectbox("How many parents or children are travelling with you?",[0,1,2,3,4,5,6,7,8])
Sex = st.sidebar.selectbox("Select your Gender",["male","female"])
Pclass = st.sidebar.selectbox("Which Class is your ticket from?", [1,2,3])
Embarked = st.sidebar.selectbox("Where did you board the Titanic?", ["Cherbourg","Queenstown","Southampton"])
Embarked = Embarked[0]

features = {"Age": Age,
            "Fare": Fare, 
            "SibSp": SibSp, 
            "Parch": Parch, 
            "Sex": Sex, 
            "Pclass": Pclass, 
            "Embarked":Embarked}
features_df  = pd.DataFrame([features])
st.table(features_df)  

if st.button('Predict'):    
    prediction = predict_model(model, features_df)['Label'][0]
    if prediction == 0:
        st.write('You will die !')
    else:
        st.write('you will survive !')
